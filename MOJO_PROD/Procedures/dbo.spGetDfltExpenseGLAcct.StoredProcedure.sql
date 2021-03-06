USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetDfltExpenseGLAcct]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetDfltExpenseGLAcct]
	 @VendorKey int
	 ,@ItemKey int = 0
AS --Encrypt

-- Default Expense Keys in following precedence: Item, Vendor, Company
Declare @ItemDefaultExpenseAccountKey int
Declare @VendorDefaultExpenseAccountKey int
Declare @CompanyDefaultExpenseAccountKey int
Declare @CompanyDefaultExpenseAccountFromItem tinyint

Declare @ItemAcctKey int, @ItemAcctNum varchar(100)
Declare @VendorAcctKey int, @VendorAcctNum varchar(100)
Declare @CompanyAcctKey int, @CompanyAcctNum varchar(100)

	Select @CompanyDefaultExpenseAccountKey			= ISNULL(p.DefaultExpenseAccountKey, 0)
		   ,@CompanyDefaultExpenseAccountFromItem	= ISNULL(p.DefaultExpenseAccountFromItem, 0)
		   ,@VendorDefaultExpenseAccountKey			= ISNULL(co.DefaultExpenseAccountKey , 0)
	 from	tCompany co (nolock)
			inner join tPreference p (nolock) on co.OwnerCompanyKey = p.CompanyKey
	 where	co.CompanyKey = @VendorKey

	If @CompanyDefaultExpenseAccountFromItem = 1 And @ItemKey > 0
		Select @ItemDefaultExpenseAccountKey = ExpenseAccountKey
		From   tItem (nolock)
		Where  ItemKey = @ItemKey

	Else
		Select @ItemDefaultExpenseAccountKey = 0

	-- If not found, set to 0
	Select @ItemDefaultExpenseAccountKey = ISNULL(@ItemDefaultExpenseAccountKey, 0)
		
	If @ItemDefaultExpenseAccountKey > 0
		Select @ItemAcctKey = GLAccountKey
			   ,@ItemAcctNum = AccountNumber 
		from   tGLAccount (nolock) 
		Where  GLAccountKey = @ItemDefaultExpenseAccountKey
	
	If @VendorDefaultExpenseAccountKey > 0
		Select @VendorAcctKey = GLAccountKey
		      ,@VendorAcctNum = AccountNumber 
		from   tGLAccount (nolock) 
		Where GLAccountKey = @VendorDefaultExpenseAccountKey
	
	Select @CompanyAcctKey = GLAccountKey
			,@CompanyAcctNum = AccountNumber 
	from   tGLAccount (nolock) 
	Where  GLAccountKey = @CompanyDefaultExpenseAccountKey

	Select @ItemAcctKey as ItemAcctKey,
			@ItemAcctNum as ItemAcctNum,
			@VendorAcctKey as VendorAcctKey,
			@VendorAcctNum as VendorAcctNum,
			@CompanyAcctKey as CompanyAcctKey,
			@CompanyAcctNum as CompanyAcctNum
GO
