USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLUnPostCheck]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLUnPostCheck]

	(
		@CheckKey int
		,@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Added cash basis posting
|| 11/09/09 GHL 10.513 Added unposting history 
|| 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey
|| 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
|| 02/15/13 GHL 10.565 TrackCash = 1 now 
|| 08/12/13 GHL 10.571 Added Multi Currency stuff
|| 12/30/13 GHL 10.575 Added Multi Currency to tTransactionUnpost
*/

DECLARE @TrackCash INT SELECT @TrackCash = 1

Declare @GLClosedDate smalldatetime
Declare @Customizations varchar(1000)
Declare @CheckDate smalldatetime
Declare @CompanyKey int
Declare @PostingDate smalldatetime
Declare @ClientKey int
Declare @GLCompanyKey int
Declare @ReferenceNumber varchar(100)
Declare @Description varchar(500)
Declare @Error int
Declare @UseMultiCompanyGLCloseDate tinyint
		
	Select 
		  @GLClosedDate = p.GLClosedDate
		, @Customizations = ISNULL(Customizations, '')   	
		, @CheckDate = ch.CheckDate
		, @CompanyKey = c.OwnerCompanyKey
		, @PostingDate = ch.PostingDate
		, @ClientKey = ch.ClientKey
		, @GLCompanyKey = ch.GLCompanyKey
		, @ReferenceNumber = ch.ReferenceNumber
		, @Description = ch.Description 
		, @UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
	From
		tCheck ch (nolock) 
		Inner Join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
		inner join tPreference p (nolock) on c.OwnerCompanyKey = p.CompanyKey
	Where
		ch.CheckKey = @CheckKey
	
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
			return -1
			
	if exists(Select 1 from tCheckAppl (nolock) Where CheckKey = @CheckKey and Prepay = 1)
		Return -4
			
	if exists(Select 1 from tTransaction (nolock) Where Entity = 'RECEIPT' and EntityKey = @CheckKey and Cleared = 1)
		return -3

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

	-- may be needed by cash basis
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
	
	exec @RetVal = sptCashQueue @CompanyKey, 'RECEIPT', @CheckKey, @PostingDate, @Action, 0
	
	--select * from #tCashQueue
	
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
	Select @CompanyKey, 'RECEIPT', @CheckKey, @CheckDate, @PostingDate
	   ,@UserKey, getutcdate(), @ClientKey, null, @GLCompanyKey, @ReferenceNumber, @Description
	   
	select @Error = @@ERROR, @UnpostLogKey = @@IDENTITY
	
	if @Error <> 0 
	begin
		rollback transaction 
		return -2
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
    Where Entity = 'RECEIPT' and EntityKey = @CheckKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -2
	end
                               
end

	
	Delete from tTransaction
	Where Entity = 'RECEIPT' and EntityKey = @CheckKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -2
	end

	IF @TrackCash = 1
	BEGIN	
		
		Delete from tCashTransaction
		Where Entity = 'RECEIPT' and EntityKey = @CheckKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -2
		end
		
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -2 	
		END
		
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		
		FROM #tCashTransaction 	
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -2 	
		END
	
	END
	
	Update tCheck
	Set Posted = 0
	Where CheckKey = @CheckKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -2
	end
	
commit Transaction
GO
