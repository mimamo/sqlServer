USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLUnPostJournalEntry]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLUnPostJournalEntry]

	(
		@JournalEntryKey int
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
|| 12/30/13 GHL 10.575 Added Multi Currency to tTransactionUnpost 
*/

-- Bypass cash basis process or not
DECLARE @TrackCash INT SELECT @TrackCash = 1

Declare @CompanyKey int
Declare @GLClosedDate smalldatetime
Declare @Customizations varchar(1000)
Declare @EntryDate smalldatetime
Declare @PostingDate smalldatetime
Declare @GLCompanyKey int
Declare @ReferenceNumber varchar(100)
Declare @Description varchar(1000)
Declare @Error int
Declare @UseMultiCompanyGLCloseDate tinyint
		
	Select 
		  @CompanyKey = j.CompanyKey
		, @GLClosedDate = p.GLClosedDate
		, @Customizations = ISNULL(Customizations, '')  	
		, @PostingDate = j.PostingDate
		, @EntryDate = j.EntryDate
		, @GLCompanyKey = j.GLCompanyKey
		, @ReferenceNumber = j.JournalNumber
		, @Description = j.Description
		, @UseMultiCompanyGLCloseDate = ISNULL(p.MultiCompanyClosingDate, 0)
		
	From
		tJournalEntry j (nolock) 
		inner join tPreference p (nolock) on p.CompanyKey = j.CompanyKey
	Where
		j.JournalEntryKey = @JournalEntryKey
	
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
			
	if exists(Select 1 from tTransaction (nolock) Where Entity = 'GENJRNL' and EntityKey = @JournalEntryKey and Cleared = 1)
		return -3

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

Begin Transaction

If isnull(@UserKey, 0) > 0
begin 
	declare @UnpostLogKey int
	
	Insert tTransactionUnpostLog (CompanyKey, Entity, EntityKey, EntityDate, PostingDate
       ,UnpostedBy, DateUnposted, ClientKey, VendorKey, GLCompanyKey, ReferenceNumber, Description)
	Select @CompanyKey, 'GENJRNL', @JournalEntryKey, @EntryDate, @PostingDate
	   ,@UserKey, getutcdate(), null, null, @GLCompanyKey, @ReferenceNumber, @Description
	   
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
    Where Entity = 'GENJRNL' and EntityKey = @JournalEntryKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -2
	end
                               
end


	Delete from tTransaction
	Where Entity = 'GENJRNL' and EntityKey = @JournalEntryKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -2
	end

	If @TrackCash = 1 
	begin
		Delete from tCashTransaction
		Where Entity = 'GENJRNL' and EntityKey = @JournalEntryKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -2
		end
	end

	Update tJournalEntry
	Set Posted = 0
	Where JournalEntryKey = @JournalEntryKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
commit Transaction
GO
