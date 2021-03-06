USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLUnPostVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLUnPostVoucher]
	(
		@VoucherKey int
		,@CheckClosedDate int = 1 -- When transferring voucher details, unpost/repost them ignoring closed date
		,@UserKey int = null
	)

AS --Encrypt

 /*
  || When     Who Rel   What
  || 08/17/07 GHL 8.5   Added @CheckClosedDate param for transfers  
  || 11/12/07 GHL 8.5   Added logic for WIPPostingInKey
  || 12/17/07 GHL 8.5   Changed tVoucherDetail.ExpenseAccountKey IN () to tVoucherDetail.OldExpenseAccountKey IN ()
  || 05/09/08 GHL 8.510 (21023) When doing the prebill accruals we must remember the GL account used
  ||                    It will be used during the prebill accrual reversals in spGLPostInvoice
  ||                    When unposting voucher, null accrued expense account  
  || 02/26/09 GHL 10.019 Added cash basis posting 
  || 04/16/09 GHL 10.223 Added support of tTransactionOrderAccrual to help with prebilled order accruals
  || 11/09/09 GHL 10.513 Added unposting history 
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD
  || 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 02/15/13 GHL 10.565 TrackCash = 1 now 
  || 08/05/13 GHL 10.571 Added Multi Currency stuff
  || 12/30/13 GHL 10.575 Added Multi Currency to tTransactionUnpost
 */

DECLARE @TrackCash INT SELECT @TrackCash = 1
 
Declare @GLClosedDate smalldatetime
Declare @Customizations varchar(1000)
Declare @PostingDate smalldatetime
Declare @WIPPostingInKey int
Declare @WIPPostingOutKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare	@WIPMediaAssetAccountKey int
Declare @TrackWIP int
Declare @CompanyKey int
Declare @InvoiceDate smalldatetime
Declare @VendorKey int
Declare @GLCompanyKey int
Declare @ReferenceNumber varchar(100)
Declare @Description varchar(500)
Declare @Error int
Declare @CreditCard int
Declare @Entity varchar(20)
Declare @UseMultiCompanyGLCloseDate tinyint
			
	--if exists(select 1 from tVoucherDetail Where InvoiceLineKey is not null and VoucherKey = @VoucherKey)
	--	Return -1
	
	--if exists(Select 1 from tVoucher Where VoucherKey = @VoucherKey and Downloaded = 1)
	--	return -2
		
	Select 
		 @GLClosedDate = p.GLClosedDate	
		,@Customizations = ISNULL(Customizations, '')
		,@PostingDate = v.PostingDate
		,@WIPVoucherAssetAccountKey = ISNULL(p.WIPVoucherAssetAccountKey, 0)
		,@WIPExpenseAssetAccountKey = ISNULL(p.WIPExpenseAssetAccountKey, 0)
		,@WIPMediaAssetAccountKey = ISNULL(p.WIPMediaAssetAccountKey, 0)
		,@TrackWIP = ISNULL(p.TrackWIP, 0)
		,@CompanyKey = v.CompanyKey
		,@InvoiceDate = v.InvoiceDate
		,@VendorKey = v.VendorKey
		,@GLCompanyKey = v.GLCompanyKey
		,@ReferenceNumber = v.InvoiceNumber
		,@Description = v.Description
		,@CreditCard = isnull(CreditCard, 0)
		,@UseMultiCompanyGLCloseDate = ISNULL(p.MultiCompanyClosingDate, 0)
	From
		tVoucher v (nolock) inner join tPreference p (nolock)
		on v.CompanyKey = p.CompanyKey
	Where
		v.VoucherKey = @VoucherKey

	If @CreditCard = 1
		select @Entity = 'CREDITCARD'
	else
		select @Entity = 'VOUCHER'
	
	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END
				
	If not @GLClosedDate is null and @CheckClosedDate = 1
		if @GLClosedDate > @PostingDate
			return -3
			
	if exists(Select 1 from tTransaction (nolock) Where Entity IN ('VOUCHER', 'CREDITCARD') and EntityKey = @VoucherKey and Cleared = 1)
		return -4

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

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
			ICTGLCompanyKey int null,
			
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
			
	CREATE TABLE #tVoucherCCDetail (
		VoucherKey int null
		,VoucherCCKey int null
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
	Declare @Action int Select @Action = 1 -- Posting
	Declare @CashEntity varchar(25)
	Declare @CashEntityKey varchar(25)
	Declare @CashPostingDate smalldatetime
	Declare @RetVal int
	
	exec @RetVal = sptCashQueue @CompanyKey, @Entity, @VoucherKey, @PostingDate, @Action , 0
		
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
	
		If @CashEntity IN ('VOUCHER', 'CREDITCARD')
			exec @RetVal = sptCashPostVoucher @CompanyKey, @CashEntityKey
	
		If @CashEntity = 'PAYMENT'
			exec @RetVal = sptCashPostPayment @CompanyKey, @CashEntityKey
					  	
	End
	
	
	END -- End Track Cash
		
		
Begin Transaction

If isnull(@UserKey, 0) > 0
begin 
	declare @UnpostLogKey int
	
	Insert tTransactionUnpostLog (CompanyKey, Entity, EntityKey, EntityDate, PostingDate
       ,UnpostedBy, DateUnposted, ClientKey, VendorKey, GLCompanyKey, ReferenceNumber, Description)
	Select @CompanyKey, @Entity, @VoucherKey, @InvoiceDate, @PostingDate
	   ,@UserKey, getutcdate(), null, @VendorKey, @GLCompanyKey, @ReferenceNumber, @Description
	   
	select @Error = @@ERROR, @UnpostLogKey = @@IDENTITY
	
	if @Error <> 0 
	begin
		rollback transaction 
		return -99
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
    Where Entity = @Entity and EntityKey = @VoucherKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
                               
end

	Delete from tTransaction
	Where Entity = @Entity and EntityKey = @VoucherKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Delete from tTransactionOrderAccrual
	Where Entity = @Entity and EntityKey = @VoucherKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Delete from tVoucherCCDetail
	Where VoucherKey = @VoucherKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Delete from tCashTransactionLine
		Where Entity = @Entity and EntityKey = @VoucherKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
		
	IF @TrackCash = 1
	BEGIN
	
		Delete from tCashTransaction
		Where Entity = @Entity and EntityKey = @VoucherKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
		
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99 	
		END
		
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead,ICTGLCompanyKey, Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead,ICTGLCompanyKey, 0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		FROM #tCashTransaction 	
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99 	
		END
	
	END
	
	Update tVoucher
	Set 
		Posted = 0
	Where VoucherKey = @VoucherKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Update tVoucherDetail
	Set    AccruedExpenseOutAccountKey = NULL
	Where VoucherKey = @VoucherKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

		
	IF @TrackWIP = 1
	BEGIN
	/*
		UPDATE tVoucherDetail
		SET    WIPPostingInKey = 0
		WHERE  tVoucherDetail.VoucherKey = @VoucherKey
		AND    tVoucherDetail.WIPPostingInKey = -1
		AND    tVoucherDetail.WIPPostingOutKey = 0
		AND    tVoucherDetail.OldExpenseAccountKey IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
	
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
	*/
	
		UPDATE tVoucherDetail
		SET    tVoucherDetail.WIPPostingInKey = 0
		WHERE  tVoucherDetail.VoucherKey = @VoucherKey
		AND    tVoucherDetail.WIPPostingInKey = -1
		AND    tVoucherDetail.WIPPostingOutKey = 0
		AND    tVoucherDetail.OldExpenseAccountKey in (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
		     
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
	
		UPDATE tVoucherDetail
		SET    tVoucherDetail.ExpenseAccountKey = tVoucherDetail.OldExpenseAccountKey
		WHERE  tVoucherDetail.VoucherKey = @VoucherKey
		AND    tVoucherDetail.WIPPostingInKey = -1
		AND    tVoucherDetail.WIPPostingOutKey > 0
		AND	   tVoucherDetail.OldExpenseAccountKey is not null
		AND    tVoucherDetail.ExpenseAccountKey NOT IN 
		(@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
	 
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end

	END
			
commit Transaction

return 1
GO
