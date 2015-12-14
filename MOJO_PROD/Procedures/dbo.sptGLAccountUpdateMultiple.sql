USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountUpdateMultiple]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountUpdateMultiple]
	(
	@CompanyKey int
	,@GLAccountKey int = 0
	,@AccountNumber varchar(100) = null 
	,@AccountName varchar(200) = null 
	,@Description varchar(500) = null
	,@Active int = 0 
	,@AccountType int = 0
	,@AccountTypeCash int = 0
	
	,@Rollup int = 0 -- means parent
	,@ParentAccountKey int = 0 
	,@DisplayOrder int = 0
	,@DisplayLevel int = 0
	
	,@PayrollExpense int = 0 
	,@FacilityExpense int = 0
	,@LaborIncome int = 0
	,@NoJournalEntries tinyint = 0 

	,@BankAccountNumber varchar(50) = null --  for Bank GL accounts
	,@NextCheckNumber bigint = 0 --  for Bank GL accounts
	,@DefaultCheckFormatKey int = 0 --  for Bank GL accounts
	,@MultiCompanyPayments tinyint = 0 -- for Bank GL accounts, multi company payments
	,@CurrencyID varchar(10) = NULL  -- for Bank GL accounts, the currency of the account

	,@VendorKey int = 0 -- for CC GL accounts
	,@FIName varchar(100) = NULL -- for CC GL accounts		
	,@FIID varchar(50) = NULL -- for CC GL accounts
	,@FIOrg varchar(50) = NULL -- for CC GL accounts
	,@FIUrl varchar(100) = NULL -- for CC GL accounts
	,@DefaultCCGLCompanyKey int = 0 -- for CC GL accounts
	,@CreditCardNumber varchar(100) = NULL -- for CC GL accounts
	,@CreditCardLogin varchar(1000) = NULL -- for CC GL accounts
	,@CreditCardPassword varchar(1000) = NULL -- for CC GL accounts
	,@CCType varchar(50) = NULL
	,@CCExpMonth tinyint = NULL
	,@CCExpYear smallint = NULL
	,@RestrictToGLCompany tinyint = 0 -- restricted GL accounts
	
	,@Action int = 0	-- 1 insert, 2 update, 3 delete, 0 None
	,@PerformUpdate int = 0
	,@ManualCCNumber varchar(100) = NULL
	,@ManualCCExpMonth tinyint = NULL
	,@ManualCCExpYear smallint = NULL
	,@ManualCCV varchar(50) = NULL
	,@CCDeliveryOption smallint = NULL
	
	,@VCardUserID varchar(500) = NULL
	,@VCardPW varchar(500) = NULL
	)
AS
	SET NOCOUNT ON

/*
|| When      Who Rel     What
|| 6/10/11   GHL 10.545  Creation for new GL account Flex screen
|| 8/1/11    GHL 10.546  (117808) On updates, save account type cash
||                       also make it null if same as account type
|| 8/2/11    GHL 10.546  Added GLCompanyKey and VendorKey for credit cards                     
||                       Added saving of tGLAccountUser records
|| 12/28/11  GHL 10.551  Added deletion of tGLAccountUser records if account is deleted
|| 03/16/12  GHL 10.554  Fixed logic to prevent deletion of accounts when transactions exist
|| 01/30/12  MAS 10.5.5.3	Added Credit card fields
|| 03/19/12  MFT 10.5.5.4 Added DefaultCheckFormatKey
|| 04/06/12  MAS 10.5.5.4 Changed the CC fields.  Removed FIKey and added specific FIName, FIOrg, etc..
|| 04/19/12  MAS 10.5.5.4 Don't update the CreditCardNumber if it hasn't been updated (still masked)
|| 05/16/12  RLB 10.5.5.6 (143217) changes made for CC account types and we allow change to rollup account type
|| 06/01/12  QMD 10.5.5.7 Added VisibleGLCompanyKey, NoJournalEntries
|| 06/11/12  QMD 10.5.5.7 Added MultiCompanyPayments
|| 08/07/12  KMC 10.5.5.9 (105299) Updated the @CreditCardLogin parameter to varchar(50) to match the table
|| 08/13/12  GHL 10.5.5.9 Added @RestrictToGLCompany
|| 08/20 12  RLB 10.5.5.9 (152088) Only checking if there is a voucher on credit card account that are active
|| 10/01/12  GHL 10.5.6.0 (155675) Removed GL CompanyKey
|| 10/10/12  RLB 10.5.6.1 (156579) add check for active flag
|| 10/29/12  RLB 10.5.6.1 (157719) Added DefaultCCGLCompanyKey
|| 11/27/12  RLB 10.5.6.2 (160767) added to CC Login and Password length
|| 12/06/12  RLB 10.5.6.3 (160920) added to Error message
|| 03/12/13  MFT 10.5.6.6 Added CCType, CCExpMonth & CCExpYear for printMedia customization
|| 05/20/13  GHL 10.5.6.8 (178882) Removed VisibleGLCompanyKey, replaced by RestrictToGLCompany/tGLCompanyAccess
|| 07/02/13  GHL 10.5.6.9 (182949) Added resetting of Rollup flag when there are no underlying accounts (prevent sticky Rollup)
|| 08/26/13  WDF 10.5.7.1 (187933) Enhanced the error message for '@kErrHasTransactions'
|| 09/03/13  GHL 10.5.7.2 Added CurrencyID for Bank accounts
|| 09/11/13  RLB 10.5.7.2 Fix when changing from rollup to nonrollup do not check any deleted rows for parentkey
|| 01/28/14  GHL 10.5.7.6 Checking now for invalid currency on cash and credit cards
|| 02/19/14  GHL 10.5.7.6 Checking now for invalid currency on AR AP 
|| 10/06/14  CRG 10.5.8.5 Added the Manual CC fields
|| 03/27/15  CRG 10.5.9.0 Added VCardUserID and VCardPW
*/


	declare @kActionInsert int			select @kActionInsert = 1
	declare @kActionUpdate int			select @kActionUpdate = 2
	declare @kActionDelete int			select @kActionDelete = 3
	declare @kActionNone int			select @kActionNone = 0

	declare @kErrDupNumber int			select @kErrDupNumber = -1
	declare @kErrHasTransactions int	select @kErrHasTransactions = -2
	declare @kErrDupRE int				select @kErrDupRE = -3
	declare @kErrHasChildren int		select @kErrHasChildren = -4
	declare @kErrMissingParent int		select @kErrMissingParent = -5
	declare @kErrRollupChangeType int	select @kErrRollupChangeType = -6
	declare @kErrCCMissingVendor int	select @kErrCCMissingVendor = -7
	declare @kErrInvalidCurrency int	select @kErrInvalidCurrency = -8

	declare @Error int
	declare @TransMsg varchar(1000)
	declare @Sep char(1)
	
	IF @VCardPW IS NULL AND @GLAccountKey > 0
		SELECT	@VCardPW = VCardPW
		FROM	tGLAccount (nolock)
		WHERE	GLAccountKey = @GLAccountKey
	
	
/* Done in VB
 create table #glaccount (
	GLAccountKey int null
	,AccountNumber varchar(100) null
	,AccountName varchar(200) null
	,Description varchar(500) null
	,Active int null
	,AccountType int null
	,AccountTypeCash int null
	
	,[Rollup] int null 
	,ParentAccountKey int null
	,DisplayOrder int null
	,DisplayLevel int null
	
	,PayrollExpense int null
	,FacilityExpense int null
	,LaborIncome int null
	,NoJournalEntries tinyint null
	
	,BankAccountNumber varchar(50) null
	,NextCheckNumber bigint null
	,DefaultCheckFormatKey int null
    ,MultiCompanyPayments tinyint null
	,CurrencyID varchar(50) null
	
	,VendorKey int null
	,FIName varchar(100) null 
    ,FIID varchar(50) null
    ,FIOrg varchar(50) null
    ,FIUrl varchar(100) null
    ,CreditCardNumber varchar(100) null
    ,CreditCardLogin varchar(50) null
    ,CreditCardPassword varchar(100) null
    
	,RestrictToGLCompany tinyint null

	,Action int null -- 1 insert, 2 update, 3 delete
	,UpdateFlag int null
	,HasTransactions int null
	,ErrNum int null
	,ErrDesc varchar(200) null
	,OldParentAccountKey int null
	,OldGLAccountKey int null
	,CurrentType int null
	,CurrentRollup int null
	
	,ManualCCNumber varchar(100) null
	,ManualCCExpMonth tinyint null
	,ManualCCExpYear smallint null
	,ManualCCV varchar(50) null
	,CCDeliveryOption smallint null
	
	,VCardUserID varchar(500) null
	,VCardPW varchar(500) null
	)

*/

/*
Technical Notes:

The stored proc is called n times, once for each GL account modified on the UI (with PerformUpdate = 0)
Then it is called one more time to perform the actual inserts/updates/deletes (with PerformUpdate = 1)

The tables affected are:

tGLAccount (from #glaccount)
tGLAccountUser (from #users) for credit cards only
tGLCompanyAccess (from #glcompanies) for restricted accounts
tGLAccountMultiCompanyPayments (but done mostly in VB code) for bank accounts 

If you add fields to tGLAccount, modify sptGLAccountGetListTX
*/

	if @PerformUpdate = 0
	begin
		if ISNULL(@GLAccountKey, 0) > 0
			begin
				Select @CreditCardNumber = CASE LEFT(@CreditCardNumber, 1) WHEN '*' THEN CreditCardNumber ELSE @CreditCardNumber END
				From tGLAccount (nolock)
				Where GLAccountKey = @GLAccountKey
			end
		
		insert #glaccount (
		GLAccountKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup],ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber, DefaultCheckFormatKey, CurrencyID
		,VendorKey,FIName,FIID,FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword 
		,Action,UpdateFlag, NoJournalEntries, MultiCompanyPayments,RestrictToGLCompany,CCType,CCExpMonth,CCExpYear
		,ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW)
		
		select
		@GLAccountKey, @AccountNumber ,@AccountName, @Description, @Active ,@AccountType ,@AccountTypeCash
	    ,@Rollup,@ParentAccountKey ,@DisplayOrder ,@DisplayLevel 
		,@PayrollExpense ,@FacilityExpense ,@LaborIncome  ,@BankAccountNumber ,@NextCheckNumber, @DefaultCheckFormatKey, @CurrencyID
		, @VendorKey,@FIName,@FIID,@FIOrg,@FIUrl,@DefaultCCGLCompanyKey,@CreditCardNumber,@CreditCardLogin,@CreditCardPassword
		,@Action,0,@NoJournalEntries,@MultiCompanyPayments,@RestrictToGLCompany,@CCType,@CCExpMonth,@CCExpYear
		,@ManualCCNumber, @ManualCCExpMonth, @ManualCCExpYear, @ManualCCV, @CCDeliveryOption, @VCardUserID, @VCardPW
		
		return 1
	end

		-- we limit the # of records to update because DisplayOrder may be changed by the UI
		-- and cause the GL account to be declared dirty when in fact, it is not
		-- DisplayOrders will be recalculated here based on AccountNumber and ParentAccountKey

	update #glaccount
	set    #glaccount.AccountTypeCash = null -- if null, same as accrual
	where  #glaccount.AccountTypeCash = #glaccount.AccountType
	

	update #glaccount
	set    #glaccount.Action = @kActionNone
	from   tGLAccount gla (nolock)
	where  #glaccount.GLAccountKey = gla.GLAccountKey
	and    #glaccount.AccountNumber = gla.AccountNumber collate database_default
	and    #glaccount.AccountName = gla.AccountName collate database_default
	and    isnull(#glaccount.Description, '') = isnull(gla.Description, '') collate database_default
	and    #glaccount.Active = gla.Active
	and    #glaccount.AccountType = gla.AccountType
	and    isnull(#glaccount.AccountTypeCash, 0) = isnull(gla.AccountTypeCash, 0)
	and    #glaccount.[Rollup] = gla.[Rollup]
	and    isnull(#glaccount.ParentAccountKey, 0) = isnull(gla.ParentAccountKey, 0)
	and    #glaccount.PayrollExpense = gla.PayrollExpense
	and    #glaccount.FacilityExpense = gla.FacilityExpense
	and    #glaccount.LaborIncome = gla.LaborIncome
	and    isnull(#glaccount.BankAccountNumber, '') = isnull(gla.BankAccountNumber, '') collate database_default
	and    isnull(#glaccount.NextCheckNumber, '') = isnull(gla.NextCheckNumber, '')
	and    isnull(#glaccount.VendorKey,0) = isnull(gla.VendorKey,0)
	and    isnull(#glaccount.CurrencyID, '') = isnull(gla.CurrencyID, '') collate database_default

	-- new fields
	and    isnull(#glaccount.FIName, '') = isnull(gla.FIName, '') collate database_default
	and    isnull(#glaccount.FIID, '') = isnull(gla.FIID, '') collate database_default
	and    isnull(#glaccount.FIOrg, '') = isnull(gla.FIOrg, '') collate database_default
	and    isnull(#glaccount.FIUrl, '') = isnull(gla.FIUrl, '') collate database_default
	and    isnull(#glaccount.DefaultCCGLCompanyKey, 0) = isnull(gla.DefaultCCGLCompanyKey, 0) 
	and    isnull(#glaccount.CreditCardNumber, '') = isnull(gla.CreditCardNumber, '') collate database_default
	and    isnull(#glaccount.CreditCardLogin, '') = isnull(gla.CreditCardLogin, '') collate database_default
	and    isnull(#glaccount.CreditCardPassword, '') = isnull(gla.CreditCardPassword, '') collate database_default

	and    isnull(#glaccount.DefaultCheckFormatKey, 0) = isnull(gla.DefaultCheckFormatKey, 0) 
	and    isnull(#glaccount.NoJournalEntries, 0) = isnull(gla.NoJournalEntries, 0) 
	and    isnull(#glaccount.MultiCompanyPayments, 0) = isnull(gla.MultiCompanyPayments, 0)
	and    isnull(#glaccount.RestrictToGLCompany, 0) = isnull(gla.RestrictToGLCompany, 0)
	and    isnull(#glaccount.CCType, '') = isnull(gla.CCType, '') collate database_default
	and    isnull(#glaccount.CCExpMonth, 0) = isnull(gla.CCExpMonth, 0)
	and    isnull(#glaccount.CCExpYear, 0) = isnull(gla.CCExpYear, 0)

	and    isnull(#glaccount.ManualCCNumber, '') = isnull(gla.ManualCCNumber, '') collate database_default
	and    isnull(#glaccount.ManualCCExpMonth, 0) = isnull(gla.ManualCCExpMonth, 0)
	and    isnull(#glaccount.ManualCCExpYear, 0) = isnull(gla.ManualCCExpYear, 0)
	and    isnull(#glaccount.ManualCCV, '') = isnull(gla.ManualCCV, '') collate database_default
	and    isnull(#glaccount.CCDeliveryOption, 0) = isnull(gla.CCDeliveryOption, 0)
	
	and    isnull(#glaccount.VCardUserID, '') = isnull(gla.VCardUserID, '') collate database_default
	and    isnull(#glaccount.VCardPW, '') = isnull(gla.VCardPW, '') collate database_default --If it's NULL, use the existing value
	
	and    #glaccount.Action = @kActionUpdate


		-- cleanup gl accounts

		delete #glaccount where GLAccountKey <=0 and Action=@kActionDelete

		update #glaccount set ParentAccountKey = null where ParentAccountKey = 0
		update #glaccount set AccountTypeCash = null where AccountTypeCash = 0
		 
		update #glaccount
		set    Action = @kActionInsert
		where  GLAccountKey <=0

		update #glaccount
		set    OldGLAccountKey = GLAccountKey
		where  Action=@kActionInsert

		update #glaccount
		set    OldParentAccountKey = ParentAccountKey
	
	-- place all remaining accounts in the temp table
		insert #glaccount (
		GLAccountKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup],ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName, FIID, FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword
		,Action,UpdateFlag, NoJournalEntries,MultiCompanyPayments,RestrictToGLCompany,CCType,CCExpMonth,CCExpYear 
		,ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW)
		
		select
		GLAccountKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,Rollup,ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName, FIID, FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword  
		,@kActionNone,0, NoJournalEntries, MultiCompanyPayments,RestrictToGLCompany,CCType,CCExpMonth,CCExpYear
		,ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW
		from tGLAccount (nolock)
		where CompanyKey = @CompanyKey
		and   GLAccountKey not in (select GLAccountKey from #glaccount)

		update #glaccount
		set    #glaccount.CurrentType = gl.AccountType
		      ,#glaccount.CurrentRollup = gl.Rollup
		from  tGLAccount gl (nolock)
		where #glaccount.GLAccountKey = gl.GLAccountKey

		update #glaccount
		set    #glaccount.CurrentType = #glaccount.AccountType
		      ,#glaccount.CurrentRollup = #glaccount.Rollup
		where  #glaccount.Action = @kActionInsert


	-- validations first
		update #glaccount
		set    #glaccount.ErrNum = 0

		-- for inserts, check that the Account is unique
		update #glaccount
		set    #glaccount.ErrNum = @kErrDupNumber 
		where  #glaccount.Action in ( @kActionInsert, @kActionUpdate)
		and    exists (select 1 from #glaccount b
			 where b.AccountNumber = #glaccount.AccountNumber
			 and   b.GLAccountKey <> #glaccount.GLAccountKey 
			 )
	
		-- flag if we have to check transactions
		-- first if we delete
		update #glaccount
		set    #glaccount.UpdateFlag = 0

		update #glaccount
		set    #glaccount.UpdateFlag = 1
		where  #glaccount.Action = @kActionDelete

		-- second if we go from Rollup 0 to 1
		update #glaccount
		set    #glaccount.UpdateFlag = 1
		where  #glaccount.Action = @kActionUpdate
		and    [Rollup] <> CurrentRollup
		and    [Rollup] = 1

if exists (select 1 from #glaccount where UpdateFlag = 1)
begin
        set @Sep = ', '
     
		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Vouchers'
		from    tVoucher (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tVoucher.APAccountKey  

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Voucher Details'
		from    tVoucherDetail (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tVoucherDetail.ExpenseAccountKey  

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Invoices'
		from    tInvoice (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tInvoice.ARAccountKey

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Invoice Lines'
		from    tInvoiceLine (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tInvoiceLine.SalesAccountKey
				
		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Checks'
		from    tCheck (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tCheck.CashAccountKey			

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Check Appls'
		from    tCheckAppl (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tCheckAppl.SalesAccountKey			

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Payments'
		from    tPayment (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tPayment.CashAccountKey	
			
		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Payment Details'
		from    tPaymentDetail (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tPaymentDetail.GLAccountKey	

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Items'
		from    tItem (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tItem.ExpenseAccountKey		

		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Journal Entry Details'
		from    tJournalEntryDetail (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tJournalEntryDetail.GLAccountKey
		
		update  #glaccount
		set     #glaccount.HasTransactions = 1
		       ,#glaccount.TransType = ISNULL(#glaccount.TransType, '') + ISNULL(@Sep, '') + 'Other Trans'
		from    tTransaction (nolock)
		where   #glaccount.UpdateFlag = 1 -- means check trans
		and     #glaccount.GLAccountKey = tTransaction.GLAccountKey				
	
		update  #glaccount
		set     #glaccount.ErrNum = @kErrHasTransactions
		where   #glaccount.HasTransactions = 1

	    select @TransMsg = RIGHT(TransType, LEN(TransType) - 1)
		  from #glaccount
		 where ErrNum = @kErrHasTransactions
		
end

	-- Reset the Rollup flag if there are no GL accounts under it
	update  #glaccount
	set     #glaccount.[Rollup] = 0
	       ,#glaccount.Action = @kActionUpdate -- since we are changing the Rollup flag, we need to update below
	where   #glaccount.[Rollup] = 1
	and not exists (select 1 from #glaccount b where b.ParentAccountKey = #glaccount.GLAccountKey and b.Action <> @kActionDelete)


	update  #glaccount
	set     #glaccount.ErrNum = @kErrCCMissingVendor
	where   #glaccount.AccountType = 23 -- Credit Card Liability
	and     isnull(#glaccount.VendorKey, 0) = 0 and #glaccount.[Rollup] = 0 and #glaccount.Active = 1

	
	-- can only have 1 retained earnings
	declare @RECount int 
	select @RECount = count(*) from #glaccount where AccountType = 32 and Action <> @kActionDelete

	if @RECount > 1
	update #glaccount set ErrNum = @kErrDupRE where AccountType = 32 

	update #glaccount
	set    #glaccount.ErrNum = @kErrHasChildren
	where  #glaccount.Action = @kActionUpdate
	and    [Rollup] <> CurrentRollup
	and    [Rollup] = 0
	and    exists (select 1 from #glaccount b where b.ParentAccountKey = #glaccount.GLAccountKey and Action <> @kActionDelete)  

--	update #glaccount
--	set    #glaccount.ErrNum = @kErrRollupChangeType
--	where  #glaccount.Action = @kActionUpdate
--	and    CurrentRollup = 1
--	and    AccountType <> CurrentType
--	And    CurrentType <> 0 
	
	
	update #glaccount
	set    #glaccount.ErrNum = @kErrMissingParent
	where  #glaccount.Action in ( @kActionUpdate, @kActionInsert)
	and    ParentAccountKey is not null
	and    ParentAccountKey not in (select b.GLAccountKey from #glaccount b where b.GLAccountKey <> #glaccount.GLAccountKey )
	
	declare @HomeCurrencyID varchar(10)
	declare @MultiCurrency int
	select  @HomeCurrencyID = CurrencyID
	       ,@MultiCurrency = MultiCurrency
	from    tPreference  (nolock)
	where   CompanyKey = @CompanyKey

	if isnull(@MultiCurrency, 0) = 1
	begin
		update #glaccount
		set    #glaccount.ErrNum = @kErrInvalidCurrency
		where  #glaccount.Action in ( @kActionUpdate, @kActionInsert)
		and    #glaccount.AccountType in (10, 11, 20, 23) -- cash account +  AR AP + credit cards
		and    #glaccount.CurrencyID is not null
		and    #glaccount.CurrencyID collate database_default not in (select CurrencyID from tCurrency (nolock) ) 

		update #glaccount
		set    #glaccount.ErrNum = @kErrInvalidCurrency
		where  #glaccount.Action in ( @kActionUpdate, @kActionInsert)
		and    #glaccount.AccountType in (10, 11, 20, 23) -- cash account +  AR AP + credit cards
		and    #glaccount.CurrencyID = @HomeCurrencyID
		
		update #glaccount
		set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': The currency is invalid'
		where  ErrNum = @kErrInvalidCurrency
	end

	update #glaccount
	set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': An account with this number already exists'
	where  ErrNum = @kErrDupNumber

	update #glaccount
	set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': This account cannot be deleted because the following transactions are tied to it - ' + @TransMsg
	where  ErrNum = @kErrHasTransactions
	and    Action = @kActionDelete

	update #glaccount
	set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': This account cannot be a rollup account because the following transactions are tied to it - ' + @TransMsg
	where  ErrNum = @kErrHasTransactions
	and    Action <> @kActionDelete

	update #glaccount
	set    ErrDesc =  'Account Number ' + isnull(AccountNumber, '') + ': A Retained Earnings account must be unique'
	where  ErrNum = @kErrDupRE

	update #glaccount
	set    ErrDesc =  'Account Number ' + isnull(AccountNumber, '') + ': This account must be a rollup account because it has subaccounts'
	where  ErrNum = @kErrHasChildren

	update #glaccount
	set    ErrDesc =  'Account Number ' + isnull(AccountNumber, '') + ': You can not change the account type on a rollup account'
	where  ErrNum = @kErrRollupChangeType

	update #glaccount
	set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': The rollup account of this account cannot be found'
	where  ErrNum = @kErrMissingParent

	update #glaccount
	set    ErrDesc = 'Account Number ' + isnull(AccountNumber, '') + ': A vendor is required for Credit Card accounts'
	where  ErrNum = @kErrCCMissingVendor

	-- End validation
	if exists (select 1 from #glaccount where ErrNum <> 0)
		return -1 -- Expected error

	begin tran

	-- now do inserts, do rollup first
	declare @OldGLAccountKey int
	select @OldGLAccountKey = 9999
	while (1=1)
	begin
		select @OldGLAccountKey = max(OldGLAccountKey)
		from   #glaccount
		where  Action = @kActionInsert
		and    OldGLAccountKey < 0
		and    [Rollup] = 1
		and    OldGLAccountKey < @OldGLAccountKey

		if @OldGLAccountKey is null
			break

		-- do not insert negative parent, we will capture later
		select @ParentAccountKey = ParentAccountKey
		from   #glaccount
		where OldGLAccountKey =@OldGLAccountKey

		if @ParentAccountKey < 0
			select @ParentAccountKey = null
					  
		insert tGLAccount (
		CompanyKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup],ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName,FIID,FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword
		,NoJournalEntries,MultiCompanyPayments, RestrictToGLCompany, CCType, CCExpMonth, CCExpYear
		, ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW
		)
		select @CompanyKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup], @ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName,FIID,FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword
		,NoJournalEntries,MultiCompanyPayments, RestrictToGLCompany, CCType, CCExpMonth, CCExpYear
		, ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW
		from #glaccount
		where OldGLAccountKey =@OldGLAccountKey

		select @Error = @@ERROR, @GLAccountKey = @@IDENTITY
		if @Error <> 0
		begin
			rollback tran
			return -2 -- Unexpected error
		end
					
		update  #glaccount set GLAccountKey = @GLAccountKey where OldGLAccountKey = @OldGLAccountKey
		update  #glaccount set ParentAccountKey = @GLAccountKey where OldParentAccountKey = @OldGLAccountKey

	end

	-- there is a risk that we had problems with multiple levels of parents
	update tGLAccount
	set    tGLAccount.ParentAccountKey = a.ParentAccountKey
	from   #glaccount a 
	where  tGLAccount.GLAccountKey = a.GLAccountKey
	and    tGLAccount.CompanyKey = @CompanyKey
	and    a.Action = @kActionInsert
	and    a.[Rollup] = 1

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- Now insert children
	select @OldGLAccountKey = 9999
	while (1=1)
	begin
		select @OldGLAccountKey = max(OldGLAccountKey)
		from   #glaccount
		where  Action = @kActionInsert
		and    OldGLAccountKey < 0
		and    [Rollup] = 0
		and    OldGLAccountKey < @OldGLAccountKey

		if @OldGLAccountKey is null
			break
	  
		insert tGLAccount (
		CompanyKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup],ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName,FIID,FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword
		,NoJournalEntries,MultiCompanyPayments,RestrictToGLCompany,CCType,CCExpMonth,CCExpYear
		, ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW
		)
		select @CompanyKey, AccountNumber ,AccountName, Description, Active ,AccountType ,AccountTypeCash
	    ,[Rollup], ParentAccountKey ,DisplayOrder ,DisplayLevel 
		,PayrollExpense ,FacilityExpense ,LaborIncome  ,BankAccountNumber ,NextCheckNumber ,DefaultCheckFormatKey, CurrencyID
		, VendorKey,FIName,FIID,FIOrg,FIUrl,DefaultCCGLCompanyKey,CreditCardNumber,CreditCardLogin,CreditCardPassword
		,NoJournalEntries,MultiCompanyPayments,RestrictToGLCompany,CCType,CCExpMonth,CCExpYear
		, ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV, CCDeliveryOption, VCardUserID, VCardPW
		from #glaccount
		where OldGLAccountKey =@OldGLAccountKey

		select @Error = @@ERROR, @GLAccountKey = @@IDENTITY
		if @Error <> 0
		begin
			rollback tran
			return -2 -- Unexpected error
		end
		
		update  #glaccount set GLAccountKey = @GLAccountKey where OldGLAccountKey = @OldGLAccountKey

	end

	-- updates
	update tGLAccount
	set    tGLAccount.AccountNumber = b.AccountNumber collate database_default
	      ,tGLAccount.AccountName = b.AccountName collate database_default
		  ,tGLAccount.Description = b.Description collate database_default
		  ,tGLAccount.Active = b.Active
		  ,tGLAccount.AccountType = b.AccountType
		   ,tGLAccount.AccountTypeCash = b.AccountTypeCash
		  ,tGLAccount.[Rollup] = b.[Rollup]
		  ,tGLAccount.ParentAccountKey = b.ParentAccountKey
		  ,tGLAccount.DisplayOrder = b.DisplayOrder
		  ,tGLAccount.DisplayLevel = b.DisplayLevel
		  ,tGLAccount.PayrollExpense = b.PayrollExpense
		  ,tGLAccount.FacilityExpense = b.FacilityExpense
		  ,tGLAccount.LaborIncome = b.LaborIncome
		  ,tGLAccount.BankAccountNumber = b.BankAccountNumber
		  ,tGLAccount.NextCheckNumber = b.NextCheckNumber
		  ,tGLAccount.CurrencyID = b.CurrencyID
		  ,tGLAccount.VendorKey = b.VendorKey
		  ,tGLAccount.FIName = b.FIName
		  ,tGLAccount.FIID = b.FIID
		  ,tGLAccount.FIOrg = b.FIOrg
		  ,tGLAccount.FIUrl = b.FIUrl
		  ,tGLAccount.DefaultCCGLCompanyKey = b.DefaultCCGLCompanyKey
		  ,tGLAccount.CreditCardNumber = b.CreditCardNumber
		  ,tGLAccount.CreditCardLogin = b.CreditCardLogin
		  ,tGLAccount.CreditCardPassword = b.CreditCardPassword
		  ,tGLAccount.DefaultCheckFormatKey = b.DefaultCheckFormatKey
		  ,tGLAccount.NoJournalEntries = b.NoJournalEntries
		  ,tGLAccount.MultiCompanyPayments = b.MultiCompanyPayments
		  ,tGLAccount.RestrictToGLCompany = b.RestrictToGLCompany
		  ,tGLAccount.CCType = b.CCType
		  ,tGLAccount.CCExpMonth = b.CCExpMonth
		  ,tGLAccount.CCExpYear = b.CCExpYear
		  ,tGLAccount.ManualCCNumber = b.ManualCCNumber
		  ,tGLAccount.ManualCCExpMonth = b.ManualCCExpMonth
		  ,tGLAccount.ManualCCExpYear = b.ManualCCExpYear
		  ,tGLAccount.ManualCCV = b.ManualCCV
		  ,tGLAccount.CCDeliveryOption = b.CCDeliveryOption
		  ,tGLAccount.VCardUserID = b.VCardUserID
		  ,tGLAccount.VCardPW = b.VCardPW
	from  #glaccount b
	where tGLAccount.GLAccountKey = b.GLAccountKey
	and   tGLAccount.CompanyKey = @CompanyKey
	and   b.Action = @kActionUpdate

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- deletes
	delete tGLAccount 
	from   #glaccount b
	where  tGLAccount.GLAccountKey = b.GLAccountKey
	and    tGLAccount.CompanyKey = @CompanyKey
	and    b.Action = @kActionDelete

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- Now preprocess the tGLAccountMultiCompanyPayments records (coded by Q in vb code)
	----------------------------------------------------------------------------------

	-- delete child records if we delete gl accounts
	-- delete child records if the gl account is not multi company anymore
	-- delete child records if not a bank account
	-- delete child records if the gl account is a rollup account
	delete tGLAccountMultiCompanyPayments
	from   #glaccount b
	where  tGLAccountMultiCompanyPayments.GLAccountKey = b.GLAccountKey
	and    tGLAccountMultiCompanyPayments.CompanyKey = @CompanyKey
	and    (b.Action = @kActionDelete
		Or
			b.MultiCompanyPayments = 0
		Or
			b.AccountType <> 10
		Or
			b.Rollup = 1
			)
			

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end
	
	-- Now inserts the tGLAccountUser records for the credit cards
	-----------------------------------------

	update #users
	set    #users.GLAccountKey = b.GLAccountKey
	from   #glaccount b
	where  #users.GLAccountKey < 0
	and    #users.GLAccountKey = b.OldGLAccountKey

	-- we removed the #glaccount to delete and where GLAccountKey < 0
	-- so delete the negative gl accounts now  
	delete #users where GLAccountKey < 0

	-- delete users if the GL account is deleted
	-- delete users if the GL account is not a credit card
	-- delete users if the GL account is Rollup
	delete #users
	from   #glaccount b
	where  #users.GLAccountKey = b.GLAccountKey   
	and    (b.Action = @kActionDelete
		    Or
			b.AccountType <> 23
			Or
			b.Rollup = 1
			)
			
	delete #users
	where  GLAccountKey not in (select GLAccountKey from #glaccount)

	-- now delete in permanent table
	delete tGLAccountUser 
	from   #glaccount b
	where  tGLAccountUser.GLAccountKey = b.GLAccountKey   

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- and insert in permanent table
	insert tGLAccountUser (GLAccountKey, UserKey) 
	select GLAccountKey, UserKey
	from   #users

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- Now inserts the gl company records for the restricted gl accounts
	-----------------------------------------

	update #glcompanies
	set    #glcompanies.GLAccountKey = b.GLAccountKey
	from   #glaccount b
	where  #glcompanies.GLAccountKey < 0
	and    #glcompanies.GLAccountKey = b.OldGLAccountKey

	-- we removed the #glaccount to delete and where GLAccountKey < 0
	-- so delete the negative gl accounts now  
	delete #glcompanies where GLAccountKey < 0

	-- delete #glcompanies if the GL account is deleted
	-- delete #glcompanies if the GL account is not a credit card
	-- delete #glcompanies if the GL account is Rollup
	delete #glcompanies
	from   #glaccount b
	where  #glcompanies.GLAccountKey = b.GLAccountKey   
	and    (b.Action = @kActionDelete
		    Or
			isnull(b.RestrictToGLCompany, 0) = 0
			Or
			b.Rollup = 1
			)
			
	delete #glcompanies
	where  GLAccountKey not in (select GLAccountKey from #glaccount)

	-- now delete in permanent table
	delete tGLCompanyAccess 
	where  tGLCompanyAccess.CompanyKey = @CompanyKey   
	and    tGLCompanyAccess.Entity = 'tGLAccount'

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	-- and insert in permanent table
	insert tGLCompanyAccess (Entity, EntityKey, GLCompanyKey, CompanyKey) 
	select 'tGLAccount', GLAccountKey, GLCompanyKey, @CompanyKey
	from   #glcompanies

	if @@ERROR <> 0
	begin
		rollback tran
		return -2 -- Unexpected error
	end

	commit tran

	EXEC sptGLAccountOrder @CompanyKey, 0, 0, -1

	update #glaccount
	set    #glaccount.DisplayOrder = b.DisplayOrder
	from   tGLAccount b (nolock)
	where  b.GLAccountKey = #glaccount.GLAccountKey


	select @DisplayOrder = -1
	while (1=1)
	begin
		select @DisplayOrder = min(DisplayOrder)
		from   #glaccount
		where  [Rollup] = 1
		and    DisplayOrder > @DisplayOrder

		if @DisplayOrder is null
			break

		select @GLAccountKey = GLAccountKey
		      ,@AccountType = AccountType
		from   #glaccount (nolock)
		where  [Rollup] = 1
		and    DisplayOrder = @DisplayOrder

		EXEC sptGLAccountCascadeAccountTypeChange @GLAccountKey, @AccountType
	end


	RETURN 1
GO
