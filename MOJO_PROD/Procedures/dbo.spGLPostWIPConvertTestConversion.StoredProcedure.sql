USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertTestConversion]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertTestConversion]
	(
		@CompanyKey INT
		,@AsOfDate SMALLDATETIME
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/27/07 GHL 8.5  Creation for new WIP analysis report       
  || 08/28/07 GHL 8.5  Changed var names to make it consistent with spRptWIPAnalysisProjects
  ||                   + Added check of AsOfDate          
  */
  
	SET NOCOUNT ON
	
-- Get Default Accounts
Declare @WIPLaborAssetAccountKey int, @WIPLaborAssetAccount varchar(1000), @WIPLaborAssetAccountAmount money
Declare @WIPLaborIncomeAccountKey int, @WIPLaborIncomeAccount varchar(1000), @WIPLaborIncomeAccountAmount money
Declare @WIPLaborWOAccountKey int, @WIPLaborWOAccount varchar(1000), @WIPLaborWOAccountAmount money

Declare @WIPExpenseAssetAccountKey int, @WIPExpenseAssetAccount varchar(1000), @WIPExpenseAssetAccountAmount money
Declare @WIPExpenseIncomeAccountKey int, @WIPExpenseIncomeAccount varchar(1000), @WIPExpenseIncomeAccountAmount money
Declare @WIPExpenseWOAccountKey int, @WIPExpenseWOAccount varchar(1000), @WIPExpenseWOAccountAmount money

Declare @WIPMediaAssetAccountKey int, @WIPMediaAssetAccount varchar(1000), @WIPMediaAssetAccountAmount money
Declare @WIPMediaWOAccountKey int, @WIPMediaWOAccount varchar(1000), @WIPMediaWOAccountAmount money


Select
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),

	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),

	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0)

from tPreference (nolock) 
Where CompanyKey = @CompanyKey

Select @WIPLaborAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborAssetAccountKey
Select @WIPLaborIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborIncomeAccountKey
Select @WIPLaborWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborWOAccountKey

Select @WIPExpenseAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseAssetAccountKey
Select @WIPExpenseIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseIncomeAccountKey
Select @WIPExpenseWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseWOAccountKey

Select @WIPMediaAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaAssetAccountKey
Select @WIPMediaWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaWOAccountKey


Declare @UnbilledLabor money
Declare @UnbilledOtherExpenses money
Declare @UnbilledProductionExpenses money
Declare @UnbilledMediaExpenses money

IF @AsOfDate IS NOT NULL
BEGIN

-- Labor
	-- This will include WIP + JE
	SELECT @WIPLaborAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- This will include WIP + JE
	SELECT @WIPLaborIncomeAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborIncomeAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- This will include WIP + JE
	SELECT @WIPLaborWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- Unposted to WIP Labor, Entity = WIP, Asset account
	SELECT @UnbilledLabor = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity = 'WIP'

-- Other Expenses
	-- This will include WIP + JE
	SELECT @WIPExpenseAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- This will include WIP + JE
	SELECT @WIPExpenseIncomeAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseIncomeAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- This will include WIP + JE
	SELECT @WIPExpenseWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- Unposted to WIP Other Expenses, Entity = WIP, Asset account
	SELECT @UnbilledOtherExpenses = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity = 'WIP'


-- Media Expenses/Vouchers
	-- This will include WIP + JE
	SELECT @WIPMediaAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPMediaAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- This will include WIP + JE
	SELECT @WIPMediaWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPMediaWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

	-- Unposted to WIP Media Expenses, Entity = WIP, Asset account
	SELECT @UnbilledMediaExpenses = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPMediaAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	AND    gl.Entity IN ('WIP')

END -- As Of Date not null
	
Select
 @WIPLaborAssetAccount						as WIPLaborAssetAccount
,ISNULL(@WIPLaborAssetAccountAmount, 0)		as WIPLaborAssetAccountAmount
,@WIPLaborIncomeAccount						as WIPLaborIncomeAccount
,ISNULL(@WIPLaborIncomeAccountAmount, 0)	as WIPLaborIncomeAccountAmount
,@WIPLaborWOAccount							as WIPLaborWOAccount
,ISNULL(@WIPLaborWOAccountAmount, 0)		as WIPLaborWOAccountAmount
,ISNULL(@UnbilledLabor, 0)					as UnbilledLabor

,@WIPExpenseAssetAccount					as WIPExpenseAssetAccount
,ISNULL(@WIPExpenseAssetAccountAmount, 0)	as WIPExpenseAssetAccountAmount
,@WIPExpenseIncomeAccount					as WIPExpenseIncomeAccount
,ISNULL(@WIPExpenseIncomeAccountAmount, 0)	as WIPExpenseIncomeAccountAmount
,@WIPExpenseWOAccount						as WIPExpenseWOAccount
,ISNULL(@WIPExpenseWOAccountAmount, 0)		as WIPExpenseWOAccountAmount
,ISNULL(@UnbilledOtherExpenses, 0)			as UnbilledOtherExpenses


,@WIPMediaAssetAccount						as WIPMediaAssetAccount
,ISNULL(@WIPMediaAssetAccountAmount, 0)		as WIPMediaAssetAccountAmount
,@WIPMediaWOAccount							as WIPMediaWOAccount
,ISNULL(@WIPMediaWOAccountAmount, 0)		as WIPMediaWOAccountAmount
,ISNULL(@UnbilledMediaExpenses, 0)			as UnbilledMediaExpenses

	
	RETURN 1
GO
