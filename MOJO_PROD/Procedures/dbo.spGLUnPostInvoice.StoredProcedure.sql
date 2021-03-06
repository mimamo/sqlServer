USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLUnPostInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLUnPostInvoice]

	(
		@InvoiceKey int
	   ,@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/05/07 GWG 8.411 Added a check to not allow unposting if the invoice is tied to po's tied to vouchers that have been posted. (causing an accrual problem)                  
  || 05/09/08 GHL 8.510  (21023) When doing the prebill accruals we must remember the GL account used
  ||                      It will be used during the prebill accrual reversals in spGLPostVoucher  
  ||                      When unposting an invoice, reset AccruedExpenseAccountInKey on order detail
  || 11/20/08 GHL 10.013 (40387) Modified logic for prebill accruals to allow Brothers and Co 
  ||                     to delete client invoices
  ||                     Just remove restriction on unposting here
  || 02/26/09 GHL 10.019 Added cash basis posting 
  || 04/16/09 GHL 10.223 Added support of tTransactionOrderAccrual to help with prebilled order accruals
  || 11/09/09 GHL 10.513 Added unposting history 
  || 01/29/10 GHL 10.517 Added code to make sure that PostingDate is not null
  || 07/03/12 GHL 10.557 Added tTransaction.ICTGLCompanyKey
  || 09/28/12 RLB 10.560 Add MultiCompanyGLClosingDate preference check
  || 02/15/13 GHL 10.565 TrackCash = 1 now 
  || 08/05/13 GHL 10.571 Added Multi Currency stuff
  || 12/30/13 GHL 10.575 Added Multi Currency to tTransactionUnpost
  */
  
DECLARE @TrackCash INT SELECT @TrackCash = 1
  
Declare @GLClosedDate smalldatetime
Declare @Customizations varchar(1000)
Declare @InvoiceDate smalldatetime
Declare @ParentInvoiceKey int
Declare @ParentInvoice tinyint
Declare @CompanyKey int
Declare @PostingDate smalldatetime
Declare @AdvanceBill int
Declare @ClientKey int
Declare @GLCompanyKey int
Declare @ReferenceNumber varchar(100)
Declare @Description varchar(500)
Declare @Error int
Declare @UseMultiCompanyGLCloseDate tinyint
		
	Select 
		  @GLClosedDate = p.GLClosedDate	
		, @Customizations = ISNULL(Customizations, '')
		, @InvoiceDate = i.InvoiceDate
		, @ParentInvoiceKey = ISNULL(i.ParentInvoiceKey, 0)
		, @ParentInvoice = ISNULL(i.ParentInvoice, 0)
		, @CompanyKey = i.CompanyKey
		, @PostingDate = isnull(i.PostingDate, i.InvoiceDate)
		, @AdvanceBill = i.AdvanceBill 
		, @ClientKey = i.ClientKey
		, @GLCompanyKey = i.GLCompanyKey
		, @ReferenceNumber = i.InvoiceNumber
		, @Description = i.HeaderComment 
		, @UseMultiCompanyGLCloseDate = ISNULL(p.MultiCompanyClosingDate, 0)
	From
		tInvoice i (nolock) 
	Inner join tPreference p (nolock) on i.CompanyKey = p.CompanyKey
	Where
		i.InvoiceKey = @InvoiceKey

	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END
			
	If not @GLClosedDate is null
		if @GLClosedDate > @PostingDate
			return -2
			
	if exists(Select 1 from tTransaction (nolock) Where Entity = 'INVOICE' and EntityKey = @InvoiceKey and Cleared = 1)
		return -3
		
/*		
	-- Verify that any PO's on the invoice do not have vendor invoices that have been posted as well.
	-- This would cause the voucher to unaccrue the order, but by unposting, there would be no accrual.
	If exists(Select 1 from tInvoiceLine il (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		Where
			il.InvoiceKey = @InvoiceKey and v.Posted = 1)
		Return -4
*/	

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

	-- these tables may be needed by cash basis
	CREATE TABLE #tTransaction (
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL,
			ICTGLCompanyKey int null ,

			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null
			
			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,TempTranLineKey int IDENTITY(1,1) NOT NULL
			)	 
			
	CREATE TABLE #tCashTransactionLine (
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL,
			
			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			AdvBillAmount money NULL,
			PrepaymentAmount money NULL,
			ReceiptAmount money NULL,
			
			TempTranLineKey int NULL
			)	 
			
	CREATE TABLE #tInvoiceAdvanceBillSale (
		InvoiceKey int null
		,AdvBillInvoiceKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int NULL
		)	

IF @TrackCash = 1 
	BEGIN

		CREATE TABLE #tCashQueue(
			Entity varchar(25) NULL,
			EntityKey int NULL,
			PostingDate smalldatetime NULL,
			QueueOrder int identity(1,1),
			PostingOrder int NULL,
			Action smallint NULL, 
			AdvanceBill int NULL
			)
			
		-- This table will track of which cash basis transactions are not valid anymore
		/*
		CREATE TABLE #tCashTransactionUnpost (
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Unpost int NULL)
		*/
		
		-- Just to get the same Entity's collation
		SELECT Entity, EntityKey, 1 AS Unpost INTO #tCashTransactionUnpost 
		FROM tCashTransaction (NOLOCK) WHERE 1 = 2 
			
		CREATE TABLE #tCashTransaction (
			UIDCashTransactionKey uniqueidentifier null,
			
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL, 
			ICTGLCompanyKey int null,

			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			-- Application fields
			AEntity varchar (50) NULL ,
			AEntityKey int NULL ,
			AReference varchar (100) NULL ,
			AEntity2 varchar (50) NULL ,
			AEntity2Key int NULL ,
			AReference2 varchar (100) NULL ,
			AAmount MONEY NULL,
			LineAmount MONEY NULL,
			CashTransactionLineKey INT NULL

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,UpdateTranLineKey int null
			)	 
			
	Declare @PostingOrder int
	Declare @Action int Select @Action = 1 -- UnPosting
	Declare @CashEntity varchar(25)
	Declare @CashEntityKey varchar(25)
	Declare @CashPostingDate smalldatetime
	Declare @RetVal int
	
	exec @RetVal = sptCashQueue @CompanyKey, 'INVOICE', @InvoiceKey, @PostingDate, @Action, @AdvanceBill
	
	--Select * From   #tCashQueue 
		
	INSERT #tCashTransactionUnpost (Entity, EntityKey, Unpost)
	Select Entity, EntityKey, 1
	From   #tCashQueue (NOLOCK)
	Where  Action = 1 -- UnPosting
		 
	Select @PostingOrder = -1
	While (1=1)
	Begin
		Select @PostingOrder = MIN(PostingOrder)
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder > @PostingOrder
		And    Action = 0 -- Posting
		
		If @PostingOrder is null
			break
			
		Select @CashEntity = Entity
		      ,@CashEntityKey = EntityKey
			  ,@CashPostingDate = PostingDate
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder = @PostingOrder
		And    Action = 0 -- Posting
	
		If @CashEntity = 'INVOICE'
			exec @RetVal = sptCashPostInvoice @CompanyKey, @CashEntityKey
	
		If @CashEntity = 'RECEIPT'
			exec @RetVal = sptCashPostCheck @CompanyKey, @CashEntityKey
					  	
	End
	
	
	END -- End Track Cash
		
Begin Transaction

If isnull(@UserKey, 0) > 0
begin 
	declare @UnpostLogKey int
	
	Insert tTransactionUnpostLog (CompanyKey, Entity, EntityKey, EntityDate, PostingDate
       ,UnpostedBy, DateUnposted, ClientKey, VendorKey, GLCompanyKey, ReferenceNumber, Description)
	Select @CompanyKey, 'INVOICE', @InvoiceKey, @InvoiceDate, @PostingDate
	   ,@UserKey, getutcdate(), @ClientKey, null, @GLCompanyKey, @ReferenceNumber, @Description
	   
	select @Error = @@ERROR, @UnpostLogKey = @@IDENTITY
	
	if @Error <> 0 
	begin
		rollback transaction 
		return -3
	end
		    
	Insert tTransactionUnpost(UnpostLogKey,TransactionKey,CompanyKey,DateCreated,TransactionDate
	       ,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,Memo,PostMonth,PostYear
	       ,Reversed,PostSide,ClientKey,ProjectKey,SourceCompanyKey,Cleared,DepositKey,GLCompanyKey
           ,OfficeKey,DepartmentKey,DetailLineKey,Section,Overhead,ICTGLCompanyKey,CurrencyID,ExchangeRate,HDebit,HCredit)
    Select @UnpostLogKey,TransactionKey,CompanyKey,DateCreated,TransactionDate
	       ,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,Memo,PostMonth,PostYear
	       ,Reversed,PostSide,ClientKey,ProjectKey,SourceCompanyKey,Cleared,DepositKey,GLCompanyKey
           ,OfficeKey,DepartmentKey,DetailLineKey,Section,Overhead,ICTGLCompanyKey,CurrencyID,ExchangeRate,HDebit,HCredit
    From tTransaction (nolock) 
    Where Entity = 'INVOICE' and EntityKey = @InvoiceKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end
                               
end

	Delete from tTransaction
	Where Entity = 'INVOICE' and EntityKey = @InvoiceKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Delete from tTransactionOrderAccrual
	Where Entity = 'INVOICE' and EntityKey = @InvoiceKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Delete from tInvoiceAdvanceBillSale
	Where InvoiceKey = @InvoiceKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end
	
	Delete from tCashTransactionLine
	Where Entity = 'INVOICE' and EntityKey = @InvoiceKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end
	
	IF @TrackCash = 1
	BEGIN
		
		
		Delete from tCashTransaction
		Where Entity = 'INVOICE' and EntityKey = @InvoiceKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -3
		end
		
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -3 	
		END
		
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		FROM #tCashTransaction 	
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -3 	
		END
	
	END
	
	Update tInvoice
	Set 
		Posted = 0,
		WriteoffAmount = 0
	Where InvoiceKey = @InvoiceKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	-- do this only if we are not a parent invoice
	If @ParentInvoice = 0
	BEGIN
		-- if this invoice has no parent, reset accrued expense accts linked to this invoice
		IF @ParentInvoiceKey = 0
		BEGIN	
			UPDATE tPurchaseOrderDetail 
			SET    tPurchaseOrderDetail.AccruedExpenseInAccountKey = NULL
			FROM   tInvoiceLine il (NOLOCK)
			WHERE  tPurchaseOrderDetail.InvoiceLineKey = il.InvoiceLineKey
			AND    il.InvoiceKey = @InvoiceKey
	
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return -3
			end				
		END	
		ELSE
		BEGIN
			-- there is a parent
			-- process only if all children invoices are unposted
			IF NOT EXISTS (SELECT 1 FROM tInvoice (NOLOCK) 
							WHERE ParentInvoiceKey = @ParentInvoiceKey
							AND  Posted = 1)
			BEGIN
				-- the lines are on the parent
				UPDATE tPurchaseOrderDetail 
				SET    tPurchaseOrderDetail.AccruedExpenseInAccountKey = NULL
				FROM   tInvoiceLine il (NOLOCK)
				WHERE  tPurchaseOrderDetail.InvoiceLineKey = il.InvoiceLineKey
				AND    il.InvoiceKey = @ParentInvoiceKey
		
				if @@ERROR <> 0 
				begin
					rollback transaction 
					return -3
				end
				
			END					
						
		END		
			
			
	
	END	
		
commit Transaction
GO
