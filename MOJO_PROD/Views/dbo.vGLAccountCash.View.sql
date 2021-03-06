USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vGLAccountCash]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   View [dbo].[vGLAccountCash]

As

/*
|| When      Who Rel     What
|| 6/11/09   GHL 10.027  Creation to support cash basis accounting
|| 01/31/14  GHL 10.576  Added Currency ID
*/

SELECT GLAccountKey
      ,CompanyKey
      ,AccountNumber
      ,AccountName

      -- when overriding Account Type for cash basis
      -- we may have differences of type between account and parent account
      -- so reset the parent   
      ,CASE WHEN AccountTypeCash IS NULL THEN ISNULL(ParentAccountKey, 0) ELSE 0 END AS ParentAccountKey 

      ,ISNULL(AccountTypeCash,AccountType) AS AccountType 

      ,Rollup
      ,Description
      ,BankAccountNumber
      ,CurrentBalance
      ,NextCheckNumber
      ,LastReconcileDate
      ,StatementDate
      ,StatementBalance
      ,RecStatus
      ,Active
      ,DisplayOrder

      ,CASE WHEN AccountTypeCash IS NULL THEN DisplayLevel ELSE 0 END AS DisplayLevel 

      ,LinkID
      ,PayrollExpense
      ,FacilityExpense
      ,LaborIncome
      ,LastModified
      ,CurrencyID
  FROM tGLAccount (NOLOCK)
GO
