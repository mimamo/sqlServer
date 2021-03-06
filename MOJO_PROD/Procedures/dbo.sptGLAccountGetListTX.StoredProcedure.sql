USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetListTX]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetListTX]

	@CompanyKey int
	,@ActiveOnly int = 1

AS --Encrypt

/*
|| When      Who Rel        What
|| 6/09/11   GHL 10.545     Added ActiveOnly param
|| 8/1/11    GHL 10.546     (117808) Needed AccountTypeDesc and AccountTypeCashDesc for exports
|| 8/2/11    GHL 10.546     Added GLCompany and Vendor info for credit cards
|| 01/30/12  MAS 10.5.5.3   Added Credit card fields
|| 03/19/12  MFT 10.5.5.4   Added DefaultCheckFormatKey
|| 04/07/12  MAS 10.5.5.3   Added Credit Card FI fields and removed the FIKey field
|| 06/02/12  QMD 10.5.5.7   Added VisibleGLCompanyKey, NoJournalEntries, MultiCompanyPayments
|| 08/13/12  GHL 10.5.5.8   Added RestrictToGLCompany
|| 10/01/12  GHL 10.5.6.0   Removed GLCompany. Will not be entered on the CC charge
|| 10/29/12  RLB 10.5.6.1   (157719) Added DefaultCCGLCompanyKey
|| 03/12/13  MFT 10.5.6.6   Added CCType, CCExpMonth & CCExpYear for printMedia customization
|| 03/22/13  GHL 10.5.6.6   (172643) Increased size of CC login and password (same as DB)
|| 05/20/13  GHL 10.5.6.8   (178882) Removed VisibleGLCompanyKey. Replaced by RestrictToGLCompany/tGLCompanyAccess
|| 09/03/13  GHL 10.5.7.2   Added CurrencyID for Bank accounts
|| 11/12/13  GHL 10.5.7.4   Check CurrencyLocked status for Credit Cards also
|| 11/12/13  GHL 10.5.7.7   Check CurrencyLocked status for AP AR also
|| 09/16/14  GHL 10.5.8.4   (229674) Locking now the vendor if there are some credit card charges 
|| 10/03/14  CRG 10.5.8.4   Added CCDeliveryOption, CardPoolID, SenderID, ManualCCNumber, ManualCCExpMonth, ManualCCExpYear, ManualCCV
|| 11/14/14  GAR 10.5.8.6   (236484) Added code to grab the transaction counts so we can prevent users from deleting GL accounts that 
||							appear on transactions.
|| 03/27/15  CRG 10.5.9.0   Added VCardUserID
*/

 -- we need a temp table for the ActiveOnly logic
 create table #glaccounts (
	GLAccountKey int null
	,AccountNumber varchar(100) null
	,AccountName varchar(200) null
	,Description varchar(500) null
	,Active int null
	,AccountType int null
	,AccountTypeCash int null
	,AccountTypeDesc varchar(100) null
	,AccountTypeCashDesc varchar(100) null
	
	,[Rollup] int null 
	,ParentAccountKey int null
	,DisplayOrder int null
	,DisplayLevel int null
	
	,PayrollExpense int null
	,FacilityExpense int null
	,LaborIncome int null
	,BankAccountNumber varchar(50) null
	,NextCheckNumber bigint null
	,CurrencyID varchar(10) null
	,CurrencyLocked int null

	,VendorKey int null
	,VendorLocked int null

	,FIName varchar(100) null
	,FIID varchar(50) null
	,FIOrg varchar(50) null
	,FIUrl varchar(100) null
	,DefaultCCGLCompanyKey int null
	,CreditCardNumber varchar(100) null
	,CreditCardLogin varchar(1000) null
	,CreditCardPassword varchar(1000) null
    
	,UpdateFlag int null
	,DefaultCheckFormatKey int null
	,NoJournalEntries tinyint null
	,MultiCompanyPayments tinyint null
	,RestrictToGLCompany tinyint null
	,CCType varchar(50) null
	,CCExpMonth tinyint null
	,CCExpYear smallint null
	,CCDeliveryOption smallint null
	,CardPoolID varchar(50) null
	,SenderID varchar(50) null
	,ManualCCNumber varchar(100) null
	,ManualCCExpMonth tinyint null
	,ManualCCExpYear smallint null
	,ManualCCV varchar(50) null
	,txCount smallint null
	,VCardUserID varchar(500) null
	)

  insert #glaccounts (
	GLAccountKey
	,AccountNumber
	,AccountName
	,Description
	,Active 
	,AccountType 
	,AccountTypeCash 
	
	,[Rollup]  
	,ParentAccountKey 
	,DisplayOrder 
	,DisplayLevel 
	
	,PayrollExpense 
	,FacilityExpense 
	,LaborIncome 
	,BankAccountNumber 
	,NextCheckNumber 
	,CurrencyID

	,VendorKey  

	,FIName
	,FIID
	,FIOrg
	,FIUrl
	,DefaultCCGLCompanyKey
	,CreditCardNumber
	,CreditCardLogin
	,CreditCardPassword
    
	,UpdateFlag 
	,DefaultCheckFormatKey
	,NoJournalEntries
	,MultiCompanyPayments
	,RestrictToGLCompany
	,CCType
	,CCExpMonth
	,CCExpYear
	
	,CCDeliveryOption
	,CardPoolID
	,SenderID
	,ManualCCNumber
	,ManualCCExpMonth
	,ManualCCExpYear
	,ManualCCV
	,txCount
	,VCardUserID
	)

	Select 
	tGLAccount.GLAccountKey
	,AccountNumber
	,AccountName
	,Description
	,Active 
	,AccountType 
	,AccountTypeCash 
	
	,[Rollup]  
	,ISNULL(tGLAccount.ParentAccountKey, 0) 
	,DisplayOrder 
	,DisplayLevel 
	
	,PayrollExpense 
	,FacilityExpense 
	,LaborIncome 
	,BankAccountNumber 
	,NextCheckNumber
	,CurrencyID

	,VendorKey  

	,FIName
	,FIID
	,FIOrg
	,FIUrl
	,DefaultCCGLCompanyKey
	,CreditCardNumber
	,CreditCardLogin
	,CreditCardPassword
    
	,0
	,DefaultCheckFormatKey
	,NoJournalEntries
	,MultiCompanyPayments
	,RestrictToGLCompany
	,CCType
	,CCExpMonth
	,CCExpYear
	
	,ISNULL(CCDeliveryOption, 0)
	,CardPoolID
	,SenderID
	,ManualCCNumber
	,ManualCCExpMonth
	,ManualCCExpYear
	,ManualCCV
	,(SELECT count(*) FROM tJournalEntryDetail (nolock) WHERE GLAccountKey = tGLAccount.GLAccountKey)	
	,VCardUserID
	
	from  tGLAccount (nolock)
	where tGLAccount.CompanyKey = @CompanyKey

	if @ActiveOnly = 1
	begin
		update #glaccounts set UpdateFlag = 1 where Active = 1

		-- the issue is that we have to keep the rollup accounts if they have active children
		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)

		-- do this several times because we did not use recursivity
		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)

		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)
		 
		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)
	
		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)

		update #glaccounts set UpdateFlag = 1
		where exists (select 1 from #glaccounts gla2 where gla2.ParentAccountKey = #glaccounts.GLAccountKey and gla2.Active = 1)

		delete #glaccounts where UpdateFlag = 0
	end

	update #glaccounts
	set    AccountTypeDesc = 
		case 
			when isnull(AccountType, 0) = 10 then 'Bank'
			when isnull(AccountType, 0) = 11 then 'Accounts Receivable'
			when isnull(AccountType, 0) = 12 then 'Current Asset'
			when isnull(AccountType, 0) = 13 then 'Fixed Asset'
			when isnull(AccountType, 0) = 14 then 'Other Asset'
			when isnull(AccountType, 0) = 20 then 'Accounts Payable'
			when isnull(AccountType, 0) = 21 then 'Current Liability'
			when isnull(AccountType, 0) = 22 then 'Long Term Liability'
			when isnull(AccountType, 0) = 23 then 'Credit Card'
			when isnull(AccountType, 0) = 30 then 'Equity - Does Not Close'
			when isnull(AccountType, 0) = 31 then 'Equity - Closes'
			when isnull(AccountType, 0) = 32 then 'Retained Earnings'
			when isnull(AccountType, 0) = 40 then 'Income'
			when isnull(AccountType, 0) = 41 then 'Other Income'
			when isnull(AccountType, 0) = 50 then 'Cost of Goods Sold'
			when isnull(AccountType, 0) = 51 then 'Expense'
			when isnull(AccountType, 0) = 52 then 'Other Expense'
			else ''
		end
			,AccountTypeCashDesc = 
		case 
			when isnull(AccountTypeCash, 0) = 10 then 'Bank'
			when isnull(AccountTypeCash, 0) = 11 then 'Accounts Receivable'
			when isnull(AccountTypeCash, 0) = 12 then 'Current Asset'
			when isnull(AccountTypeCash, 0) = 13 then 'Fixed Asset'
			when isnull(AccountTypeCash, 0) = 14 then 'Other Asset'
			when isnull(AccountTypeCash, 0) = 20 then 'Accounts Payable'
			when isnull(AccountTypeCash, 0) = 21 then 'Current Liability'
			when isnull(AccountTypeCash, 0) = 22 then 'Long Term Liability'
			when isnull(AccountTypeCash, 0) = 23 then 'Credit Card'
			when isnull(AccountTypeCash, 0) = 30 then 'Equity - Does Not Close'
			when isnull(AccountTypeCash, 0) = 31 then 'Equity - Closes'
			when isnull(AccountTypeCash, 0) = 32 then 'Retained Earnings'
			when isnull(AccountTypeCash, 0) = 40 then 'Income'
			when isnull(AccountTypeCash, 0) = 41 then 'Other Income'
			when isnull(AccountTypeCash, 0) = 50 then 'Cost of Goods Sold'
			when isnull(AccountTypeCash, 0) = 51 then 'Expense'
			when isnull(AccountTypeCash, 0) = 52 then 'Other Expense'
			else ''
		end

	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)

	select @MultiCurrency = MultiCurrency
	      ,@HomeCurrencyID = CurrencyID
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey

	-- I lock the Currency if there are some transactions
	if @MultiCurrency = 1
	begin
		update #glaccounts
		set    #glaccounts.CurrencyLocked = 0
		
		update #glaccounts
		set    #glaccounts.CurrencyLocked = 1
		from   tTransaction t (nolock)
		where  #glaccounts.AccountType in ( 10, 11, 20, 23) -- Bank, AP AR account or Credit Card
		and    #glaccounts.GLAccountKey = t.GLAccountKey
		and    #glaccounts.CurrencyLocked = 0

		update #glaccounts
		set    #glaccounts.CurrencyLocked = 1
		from   tCheck c (nolock)
		where  #glaccounts.AccountType in ( 10, 11, 20, 23) -- Bank, AP AR account or Credit Card
		and    #glaccounts.GLAccountKey = c.CashAccountKey
		and    #glaccounts.CurrencyLocked = 0

		update #glaccounts
		set    #glaccounts.CurrencyLocked = 1
		from   tPayment p (nolock)
		where  #glaccounts.AccountType in ( 10, 11, 20, 23) -- Bank, AP AR account or Credit Card
		and    #glaccounts.GLAccountKey = p.CashAccountKey
		and    #glaccounts.CurrencyLocked = 0
	
		update #glaccounts
		set    #glaccounts.CurrencyLocked = 1
		from   tVoucher v (nolock)
		where  #glaccounts.AccountType in ( 10, 11, 20, 23) -- Bank, AP AR account or Credit Card
		and    #glaccounts.GLAccountKey = v.APAccountKey
		and    #glaccounts.CurrencyLocked = 0

	end

	-- lock the vendor if there is a credit card charge
	update #glaccounts
	set    #glaccounts.VendorLocked = 1
	from   tVoucher v (nolock)
	where  #glaccounts.AccountType = 23 -- Credit Card
	and    #glaccounts.GLAccountKey = v.APAccountKey
	and    v.CreditCard = 1


	select gl.* 
		  ,pgl.AccountNumber as ParentAccountNumber, pgl.AccountName as ParentAccountName
          ,v.VendorID, v.CompanyName as VendorName
		  , ccgl.GLCompanyID as DefaultCCGLCompanyID, ccgl.GLCompanyName as DefaultCCGLCompanyName
		  , curr.Description as CurrencyDescription
	from #glaccounts gl 
		left join tGLAccount pgl (nolock) on gl.ParentAccountKey = pgl.GLAccountKey
		left join tCompany v (nolock) on gl.VendorKey = v.CompanyKey
		left join tGLCompany ccgl (nolock) on gl.DefaultCCGLCompanyKey = ccgl.GLCompanyKey
		left join tCurrency curr (nolock) on gl.CurrencyID = curr.CurrencyID collate database_default

	order by gl.DisplayOrder, gl.AccountNumber

/* Could not use this because of the ActiveOnly logic

 Select tGLAccount.GLAccountKey,
			tGLAccount.Active,
			tGLAccount.AccountNumber,
			tGLAccount.AccountName,
			tGLAccount.CompanyKey,
			ISNULL(tGLAccount.ParentAccountKey, 0) as ParentAccountKey, 
			CASE
				WHEN ISNULL(tGLAccount.AccountNumber, '') <> '' THEN ISNULL(tGLAccount.AccountName, '') + '-' + ISNULL(tGLAccount.AccountNumber, '')
				ELSE ISNULL(tGLAccount.AccountName, '')
			END AS FormattedName,
			CASE tGLAccount.AccountType
				WHEN 10 THEN 'Bank'
				WHEN 11 THEN 'Accounts Receivable'
				WHEN 12 THEN 'Current Asset'
				WHEN 13 THEN 'Fixed Asset'
				WHEN 14 THEN 'Other Asset'
				WHEN 20 THEN 'Accounts Payable'
				WHEN 21 THEN 'Current Liability'
				WHEN 22 THEN 'Long Term Liability'
				WHEN 30 THEN 'Equity - Does not Close'
				WHEN 31 THEN 'Equity - Closes'
				WHEN 32 THEN 'Retained Earnings'
				WHEN 40 THEN 'Income'
				WHEN 41 THEN 'Other Income'
				WHEN 50 THEN 'Cost of Goods Sold'
				WHEN 51 THEN 'Expenses'
				WHEN 52 THEN 'Other Expenses'
				ELSE 'No Type'
			END AS AccountTypeName,
			tGLAccount.AccountType,
			tGLAccount.Rollup,
			tGLAccount.Description,
			tGLAccount.BankAccountNumber,
			tGLAccount.CurrentBalance,
			tGLAccount.NextCheckNumber,
			tGLAccount.LastReconcileDate,
			tGLAccount.StatementDate,
			tGLAccount.StatementBalance,
			tGLAccount.RecStatus,
			tGLAccount.Active,
			tGLAccount.DisplayOrder,
			tGLAccount.DisplayLevel,
			tGLAccount.LinkID,
			tGLAccount.PayrollExpense,
			tGLAccount.FacilityExpense,
			tGLAccount.LaborIncome,
			tGLAccount.LastModified,
			isnull(tGLAccount.AccountTypeCash, tGLAccount.AccountType) as AccountTypeCash,			
			CASE
				WHEN tGLAccount.AccountType in (40, 41) THEN 1 --Income
				WHEN tGLAccount.AccountType in (50, 51, 52) THEN 2 --Expense
				ELSE 0 --Other
			END AS IncExpType,
			CASE
				WHEN ISNULL(tGLAccount.AccountNumber, '') <> '' THEN ISNULL(tGLAccount.AccountNumber, '') + '-' + ISNULL(tGLAccount.AccountName, '')
				ELSE ISNULL(tGLAccount.AccountName, '')
			END AS AccountNumberName,
			pgl.AccountNumber as ParentAccountNumber, pgl.AccountName as ParentAccountName,
(SELECT Count(*)
     FROM tTransaction AS tx (NOLOCK) 
     WHERE tx.GLAccountKey = tGLAccount.GLAccountKey) AS txCount						
		from tGLAccount (nolock)  
		LEFT JOIN tGLAccount pgl (nolock) on tGLAccount.ParentAccountKey = pgl.GLAccountKey
		Where tGLAccount.CompanyKey = @CompanyKey
		order by tGLAccount.DisplayOrder, tGLAccount.AccountNumber
*/
GO
