USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetCCDetail]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetCCDetail]
	(
	 @UserKey int
	,@CreditCardKey int
	,@BoughtByKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 09/08/11 GHL 10.548   Creation for CreditCardAdd.mxml
||                       Right now only used in Add screen
||                       Brings back: header (contains header + single line)
|| 09/29/11 GHL  10.548  Setting VoucherType = Overhead = 0
|| 07/02/12 GHL  10.557  Returning now GLCompanyKey
|| 10/01/12 GHL  10.560  Removing tGLAccount.GLCompanyKey...it will be now on the CC charge
|| 10/08/12 GHL  10.561  Taking in account tGLAccount.RestrictToGLCompany
|| 01/25/13 GHL  10.564  (166474) Changed approver to CreditCardApprover (instead of ExpenseApprover)
|| 07/30/13 KMC  10.570  (184557) Added check for new right purch_approvecreditcardcharge (60403).  If the
||                       CreditCardApprover is blank, and you do not have the right to approve credit card charges
||                       then the prior fall through logic to put yourself as the approver no longer happens.
|| 11/13/13 GHL  10.574  Added CurrencyID from the credit card gl account 
|| 11/24/14 GAR  10.586  (236962) Added code to grab the default Gl Company from tPreference.
*/
	SET NOCOUNT ON

/*
Called at the beginning with @CCAccountKey = 0 or null, @BoughtByKey = 0 or null
Called after a Save with @CCAccountKey = val1, @BoughtByKey = val2

*/
	declare @CompanyKey int
	declare @Administrator int
	declare @SecurityGroupKey int
	declare @CurrUserIsCreditCardUser int
	declare @AddOtherCreditCardCharges int

	-- defaults from the credit card
	declare @VendorKey int
    declare @VendorID varchar(500)
    declare @VendorName varchar(500)
    declare @SalesTaxKey int
    declare @SalesTax2Key int
    
	declare @APAccountFullName varchar(500)
	declare @APAccountNumber varchar(500)
	declare @APAccountName varchar(500)

	declare @VendorDefaultExpenseAccountKey int
	declare @VendorDefaultExpenseAccountNumber varchar(500)
	declare @VendorDefaultExpenseAccountName varchar(500)

	declare @MultiCurrency int
	declare @CurrencyID varchar(10)

	-- header defaults
	declare @kToday smalldatetime        select @kToday = convert(smalldatetime, convert(varchar(10), getdate(), 101))
	declare @CreatedByName as varchar(500)
	declare @BoughtByName as varchar(500)
	declare @ApprovedByName as varchar(500)
	declare @ApprovedByKey as int
	declare @PrefClassKey int
	declare @PrefClassID varchar(500)
	declare @PrefClassName varchar(500)
	declare @PrefDefaultExpenseAccountKey int
	declare @PrefDefaultExpenseAccountNumber varchar(500)
	declare @PrefDefaultExpenseAccountName varchar(500)
	declare @GLCompanyKey int
	declare @GLCompanyID varchar(500)
	declare @GLCompanyName varchar(500)	
	
	create table #gl (CreditCardID int identity(1,1), GLAccountKey int null, AccountNumber varchar(100) null) 

	select @CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
	      ,@CreatedByName = isnull(FirstName + ' ', '') + isnull(LastName, '')
		  ,@Administrator = isnull(Administrator, 0)
		  ,@SecurityGroupKey = isnull(SecurityGroupKey, 0)
	from   tUser (nolock)
	where  UserKey = @UserKey


-- only do this if @BoughtByKey =0/null or @CreditCardKey = 0/null i.e. first time in
if isnull(@CreditCardKey, 0) = 0
begin
	if @Administrator = 1
		select @AddOtherCreditCardCharges = 1 
	else
	begin
		if exists (select 1 from tRight r (nolock)
					inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey 
						and ra.EntityKey = @SecurityGroupKey and ra.EntityType ='Security Group'
				   where r.RightID = 'purch_addothercreditcardcharge'
				   )
				   select @AddOtherCreditCardCharges = 1
				else
				   select @AddOtherCreditCardCharges = 0
	end	
	
	-- check if user has an active credit card
	if exists (select 1 from tGLAccountUser glau (nolock)
				inner join tGLAccount gla (nolock) on glau.GLAccountKey = gla.GLAccountKey
				where glau.UserKey = @UserKey
				and   gla.Active = 1
				and   gla.AccountType = 23
			) 
			select @CurrUserIsCreditCardUser = 1
		else
			select @CurrUserIsCreditCardUser = 0

	-- if the curr user can use a credit card, he is the buyer
	if @CurrUserIsCreditCardUser = 1
		select @BoughtByKey = @UserKey
	

	-- if there are no valid credit card on valid users, abort
	if not exists (select 1 from tGLAccountUser glau (nolock)
				inner join tGLAccount gla (nolock) on glau.GLAccountKey = gla.GLAccountKey
				inner join tUser u (nolock) on glau.UserKey = u.UserKey
				where gla.CompanyKey = @CompanyKey
				and   gla.Active = 1
				and   gla.AccountType = 23
				and   u.Active = 1
				And   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
				)
				return -2	

	-- if we are not a credit card user and cannot add for others, abort
	if isnull(@BoughtByKey, 0) = 0 And @AddOtherCreditCardCharges = 0
		return -1

	
	-- if the buyer is known, get the first credit card when sorting by DisplayOrder/AccountNumber
	if isnull(@BoughtByKey, 0) > 0
	begin
		insert #gl (GLAccountKey, AccountNumber)
		select gla.GLAccountKey, gla.AccountNumber 
		from tGLAccountUser glau (nolock)
		inner join tGLAccount gla (nolock) on glau.GLAccountKey = gla.GLAccountKey
		where glau.UserKey = @BoughtByKey
		and   gla.Active = 1
		and   gla.AccountType = 23
		And   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		order by gla.DisplayOrder, gla.AccountNumber -- important
		
		select @CreditCardKey = GLAccountKey
		from  #gl where CreditCardID = 1 
	end
	else 
	begin
		-- buyer is not known

		-- now get a list of credit cards for the company
		insert #gl (GLAccountKey, AccountNumber)
		select gla.GLAccountKey, gla.AccountNumber 
		from  tGLAccountUser glau (nolock)
		inner join tGLAccount gla (nolock)  on glau.GLAccountKey = gla.GLAccountKey
		where gla.CompanyKey = @CompanyKey
		and   gla.Active = 1
		and   gla.AccountType = 23
		And   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )
		order by gla.DisplayOrder, gla.AccountNumber -- important

		select @CreditCardKey = GLAccountKey
		from  #gl where CreditCardID = 1 

		-- probably we could take the first one by alpha order
		select @BoughtByKey = UserKey
		from   tGLAccountUser (nolock)
		where  GLAccountKey = @CreditCardKey

	end

end

	if isnull(@CreditCardKey, 0) > 0
	begin
		-- get default vendor key, etc.. from credit card
		select @VendorKey = gla.VendorKey
              ,@VendorID = v.VendorID
              ,@VendorName = v.CompanyName
			  ,@SalesTaxKey = v.VendorSalesTaxKey 
			  ,@SalesTax2Key = v.VendorSalesTax2Key

			  ,@APAccountFullName = gla.AccountNumber + ' - ' + gla.AccountName
			  ,@APAccountNumber = gla.AccountNumber
			  ,@APAccountName = gla.AccountName
			  ,@CurrencyID = gla.CurrencyID

			  ,@VendorDefaultExpenseAccountKey = v.DefaultExpenseAccountKey
		from  tGLAccount gla (nolock)
		inner join tCompany v (nolock) on gla.VendorKey = v.CompanyKey
		where gla.GLAccountKey = @CreditCardKey   

		Select @VendorDefaultExpenseAccountNumber = AccountNumber
		      ,@VendorDefaultExpenseAccountName = AccountName 
		from   tGLAccount (nolock) 
		Where GLAccountKey = @VendorDefaultExpenseAccountKey

	end


	select @BoughtByName = isnull(FirstName + ' ', '') + isnull(LastName, '')
	      ,@ApprovedByKey = CreditCardApprover
	from   tUser (nolock)
	where  UserKey = @BoughtByKey

	if @ApprovedByKey > 0 and @ApprovedByKey in (SELECT UserKey
												   FROM tUser u (NOLOCK)
													  INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey
												  WHERE ra.EntityType = 'Security Group' AND RightKey = 60403)
		select @ApprovedByName = isnull(FirstName + ' ', '') + isnull(LastName, '')
		from   tUser (nolock)
		where  UserKey = @ApprovedByKey
	else
	BEGIN
		SELECT @ApprovedByKey = NULL

		-- ApprovedByKey is null, so use yourself as the approver if you have the rights
		if @UserKey in (SELECT UserKey
						  FROM tUser u (NOLOCK)
							 INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey
						 WHERE ra.EntityType = 'Security Group' AND RightKey = 60403)
			select @ApprovedByKey = @UserKey, @ApprovedByName = @CreatedByName
	END

	select @PrefClassKey = pref.DefaultClassKey 
		  ,@PrefClassID = isnull(cla.ClassID, '') 
		  ,@PrefClassName = isnull(cla.ClassName, '') 

		  ,@PrefDefaultExpenseAccountKey = pref.DefaultExpenseAccountKey 
		  ,@PrefDefaultExpenseAccountNumber = isnull(gla.AccountNumber, '') 
		  ,@PrefDefaultExpenseAccountName = isnull(gla.AccountName, '') 
		  
		  ,@MultiCurrency = isnull(MultiCurrency, 0)
	from  tPreference pref (nolock)
	left outer join tClass cla (nolock) on pref.DefaultClassKey = cla.ClassKey
	left outer join tGLAccount gla (nolock) on pref.DefaultExpenseAccountKey = gla.GLAccountKey
	where pref.CompanyKey = @CompanyKey	

	-- we will test null for this one
	if @VendorDefaultExpenseAccountKey = 0
		select @VendorDefaultExpenseAccountKey = null


	-- need tax rates and piggy back
	declare @Tax1Rate decimal(24, 4)
	declare @PiggyBackTax1 int
	declare @Tax2Rate decimal(24, 4)
	declare @PiggyBackTax2 int

	if isnull(@SalesTaxKey, 0) > 0
	select @Tax1Rate = TaxRate 
	      ,@PiggyBackTax1 = PiggyBackTax
	from tSalesTax (nolock) where SalesTaxKey = @SalesTaxKey 

	if isnull(@SalesTax2Key, 0) > 0
	select @Tax2Rate = TaxRate 
	      ,@PiggyBackTax2 = PiggyBackTax
	from tSalesTax (nolock) where SalesTaxKey = @SalesTax2Key 

	if @MultiCurrency = 0
		select @CurrencyID = null
		
	-- Get GL Company information to be used in defaulting the GL Company.
	select @GLCompanyKey = glc.GLCompanyKey
		,@GLCompanyID = glc.GLCompanyID
		,@GLCompanyName = glc.GLCompanyName
	from tPreference pref (nolock)
	inner join tGLCompany glc (nolock) on pref.DefaultGLCompanyKey = glc.GLCompanyKey
		and glc.Active = 1
	where pref.CompanyKey = @CompanyKey

	-- Voucher Header
	select 0 as VoucherKey

	      ,isnull(@CreditCardKey, 0) as APAccountKey
		  ,isnull(@APAccountNumber, '') as APAccountNumber
		  ,isnull(@APAccountName, '') as APAccountName
		  ,isnull(@APAccountFullName, '') as APAccountFullName
		  ,@CurrencyID as CurrencyID -- that comes from the GL account/credit card
		  ,1 as ExchangeRate -- temporary, will be recalculated on the UI
		  ,1 as PExchangeRate -- temporary, will be recalculated on the UI
		   
		  --,null as GLCompanyKey
		  --,'' as GLCompanyID
		  --,'' as GLCompanyName
		  
		  ,@GLCompanyKey as GLCompanyKey
		  ,@GLCompanyID as GLCompanyID
		  ,@GLCompanyName as GLCompanyName

		  ,'' as InvoiceNumber
		  ,@kToday as PostingDate
		  ,@kToday as InvoiceDate
		  ,@kToday as DateReceived
		  ,'01/01/2025' as DueDate

		  ,0 as OpeningTransaction
		  ,1 as InvoiceStatus

		  ,isnull(@PrefClassKey, 0) as ClassKey
		  ,isnull(@PrefClassID, '') as ClassID
		  ,isnull(@PrefClassName, '') as ClassName

		  ,isnull(@SalesTaxKey, 0) as SalesTaxKey
		  ,isnull(@SalesTax2Key, 0) as SalesTax2Key
		  ,isnull(@Tax1Rate, 0) as Tax1Rate
		  ,isnull(@Tax2Rate, 0) as Tax2Rate
		  ,isnull(@PiggyBackTax1, 0) as PiggyBackTax1
		  ,isnull(@PiggyBackTax2, 0) as PiggyBackTax2

		  
		  ,0 as VoucherTotal

		  ,@BoughtByKey as BoughtByKey
		  ,@BoughtByName as BoughtByName
		   
		  ,0 as BoughtFromKey
		  ,'' as BoughtFrom

		  ,@UserKey as CreatedByKey
		  ,@CreatedByName as CreatedByName
		 
		  ,@ApprovedByKey as ApprovedByKey
		  ,@ApprovedByName as ApprovedByName
	
	      ,isnull(@VendorKey, 0) as VendorKey
		  ,isnull(@VendorID, '') as VendorID
		  ,isnull(@VendorName, '') as VendorName
	
		  ,0 as VoucherType -- Overhead = 0

		-- One Single line, part of the same result set
		  ,1 as LineNumber
		   
		   ,0 as ProjectKey
		   ,'' as ProjectNumber
		   ,'' as ProjectName

		   ,0 as TaskKey
		   ,'' as TaskID
		   ,'' as TaskName

		   ,0 as ItemKey
		   ,'' as ShortDescription
		   ,1 as Quantity
		   ,0 as UnitCost
		   ,0 as TotalCost
		   ,0 as TotalCostWithTax
		   ,0 as Billable
		   ,0 as Markup
		   ,0 as UnitRate
		   ,0 as BillableCost

		   ,case when @VendorDefaultExpenseAccountKey is null 
		   then @PrefDefaultExpenseAccountKey else @VendorDefaultExpenseAccountKey  
		   end as ExpenseAccountKey

		   ,case when @VendorDefaultExpenseAccountKey is null 
		   then @PrefDefaultExpenseAccountNumber else @VendorDefaultExpenseAccountNumber  
		   end as AccountNumber

		   ,case when @VendorDefaultExpenseAccountKey is null 
		   then @PrefDefaultExpenseAccountName else @VendorDefaultExpenseAccountName  
		   end as AccountName

		   ,0 as Taxable
		   ,0 as Taxable2
		   ,0 as SalesTaxAmount  
           ,0 as SalesTax1Amount
		   ,0 as SalesTax2Amount
		  
		   ,0 as OfficeKey
		   ,'' as OfficeName
		    
           ,0 as DepartmentKey
		   ,'' as DepartmentName
		   
		   ,0 as ClientKey
		   ,'' as CustomerID
		   ,'' as ClientName
			   

	
	RETURN 1
GO
