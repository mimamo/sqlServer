USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetList]

	@CompanyKey int,
	@Active tinyint = 0


AS --Encrypt

/*
|| When      Who Rel     What
|| 6/27/07   CRG 8.5     (9562) Added DisplayOrder.
|| 7/3/07    CRG 8.5     (9562) Added AccountType 52 as an Income and Expense Type.
||                       Even though this SP is used in several places, the IncExpType column is
||                       only used by the GL Budget screen.
|| 7/3/07    CRG 8.5     (9562) Added optional @Active parameter.
|| 8/20/07   GHL 8.5     Added DDAccountFullName for Dropdowns
|| 10/17/07  CRG 8.5     Modified IncExpType to differentiate between Income and Expense for use by the Flex GL Budget screen.
||                       This column is no longer used by any other pages.
|| 06/11/09  GHL 10.027  Added AccountTypeCash to support cash basis accounting
|| 06/08/10  RLB 10.531  Added Payroll Expense and Facility Expense
|| 01/14/11  RLB 10.540  (99555) Added active so i can filter the list on it
*/

		SELECT 
			GLAccountKey,
			Active,
			AccountNumber,
			AccountName,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			Case AccountType
				When 10 then 'Bank'
				When 11 then 'Accounts Receivable'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'Accounts Payable'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity - Does Not Close'
				When 31 then 'Equity - Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'Cost of Goods Sold'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeName,
			Case isnull(AccountTypeCash, AccountType)
				When 10 then 'Bank'
				When 11 then 'Accounts Receivable'
				When 12 then 'Current Asset'
				When 13 then 'Fixed Asset'
				When 14 then 'Other Asset'
				When 20 then 'Accounts Payable'
				When 21 then 'Current Liability'
				When 22 then 'Long Term Liability'
				When 30 then 'Equity - Does Not Close'
				When 31 then 'Equity - Closes'
				When 32 then 'Retained Earnings'
				When 40 then 'Income'
				When 41 then 'Other Income'
				When 50 then 'Cost of Goods Sold'
				When 51 then 'Expenses'
				When 52 then 'Other Expenses'
			end as AccountTypeNameCash,
			Description,
			Rollup,
			Case Active When 1 then 'Active' else 'Inactive' end as ActiveStatus,
			Case PayrollExpense When 1 then 'Yes' else 'No' end as PayrollExpense,
			Case FacilityExpense When 1 then 'Yes' else 'No' end as FacilityExpense,
			AccountType,
			isnull(AccountTypeCash, AccountType) as AccountTypeCash,
			AccountNumber + ' - ' + AccountName as AccountFullName,
			left(AccountNumber + ' - ' + AccountName, 40) as DDAccountFullName,			
			DisplayLevel,
			case
				when AccountType in (40, 41) then 1 --Income
				when AccountType in (50, 51, 52) then 2 --Expense
				else 0 --Other
			end as IncExpType,
			DisplayOrder			
		FROM tGLAccount (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		((Active = @Active) OR (@Active = 0))
		ORDER BY
			DisplayOrder, AccountNumber
	RETURN 1
GO
