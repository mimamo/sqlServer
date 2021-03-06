USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWIPPosting]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWIPPosting]

	(
		@WIPPostingKey int
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 04/02/07 GHL 8.41  Changed to left join for misc cost/task 
  || 04/03/07 GHL 8.41  Added logic for @WIPRecognizeCostRev
  || 08/01/07 GHL 8.5   Removed ref to Expense Type
  || 08/15/07 GHL 8.5   Added GLCompanyName, OfficeName, DepartmentName
  || 04/27/15 WDF 8.591 (251630) Differentiate between no class key VS a class key with no class name
  */  
  
	DECLARE @WIPRecognizeCostRev int
			,@CompanyKey int
			
	-- Get the Preference Settings
	Select @WIPRecognizeCostRev = ISNULL(WIPRecognizeCostRev, 0)
	from tPreference  (nolock)
	inner join tWIPPosting (NOLOCK) on tPreference.CompanyKey = tWIPPosting.CompanyKey  
	Where tWIPPosting.WIPPostingKey = @WIPPostingKey

	SELECT  t.TransactionKey
			,v.TimeKey			AS SrcUIDTransactionKey
			,NULL				AS SrcTransactionKey
			,t.ClassKey
			,CASE 
			    WHEN t.ClassKey IS NULL THEN ''
			    ELSE ISNULL(c.ClassName, 'UNKNOWN')
			 END AS ClassName
			,t.Debit
			,t.Credit
			,Case 
			When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
			ELSE Credit - Debit END as Amount
			,gl.AccountNumber
			,gl.AccountName
			,gl.AccountType
			,'Labor'			AS SrcTransactionType
			,v.ProjectNumber	AS ProjectNumber
			,v.TaskID			AS TaskID
			,v.WorkDate			AS SrcTransactionDate
			,v.ActualHours		AS SrcQuantity
			,v.ActualRate		as SrcUnitCost
			,v.ActualTotal		AS SrcAmount
			,ISNULL(v.FirstName, '') + ' ' + ISNULL(v.LastName, '') AS SrcName
			,v.ServiceDescription AS SrcDescription
			,co.CompanyName
			,glc.GLCompanyName
			,d.DepartmentName
			,o.OfficeName
	FROM    tTransaction t (NOLOCK)
		INNER JOIN tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vTimeDetail v (NOLOCK) ON wpd.UIDEntityKey = v.TimeKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey

	WHERE   t.Entity			= 'WIP'
	AND     t.EntityKey			= @WIPPostingKey
	AND	    wpd.Entity			= 'tTime'
	AND     wpd.WIPPostingKey	= @WIPPostingKey
	
	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,v.ExpenseReceiptKey	AS SrcTransactionKey
			,t.ClassKey
			,CASE 
			    WHEN t.ClassKey IS NULL THEN ''
			    ELSE ISNULL(c.ClassName, 'UNKNOWN')
			 END AS ClassName
			,t.Debit
			,t.Credit
			,Case 
			When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
			ELSE Credit - Debit END as Amount
			,gl.AccountNumber
			,gl.AccountName
			,gl.AccountType
			,'Expense'			AS SrcTransactionType
			,v.ProjectNumber	AS ProjectNumber
			,v.TaskID			AS TaskID
			,v.ExpenseDate		AS SrcTransactionDate
			,v.ActualQty		as SrcQuantity
			,v.ActualUnitCost	as SrcUnitCost
			,v.ActualCost		AS SrcAmount
			,ISNULL(v.FirstName, '') + ' ' + ISNULL(v.LastName, '') AS SrcName
			,v.ItemName			AS SrcDescription
			,co.CompanyName
			,glc.GLCompanyName
			,d.DepartmentName
			,o.OfficeName
	FROM    tTransaction t (NOLOCK)
		INNER JOIN tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vExpenseReport v (NOLOCK) ON wpd.EntityKey = v.ExpenseReceiptKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey
	WHERE   t.Entity			= 'WIP'
	AND     t.EntityKey			= @WIPPostingKey
	AND	    wpd.Entity			= 'tExpenseReceipt'
	AND     wpd.WIPPostingKey	= @WIPPostingKey

	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,v.VoucherDetailKey		AS SrcTransactionKey
			,t.ClassKey
			,CASE 
			    WHEN t.ClassKey IS NULL THEN ''
			    ELSE ISNULL(c.ClassName, 'UNKNOWN')
			 END AS ClassName
			,t.Debit
			,t.Credit
			,Case 
			When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
			ELSE Credit - Debit END as Amount
			,gl.AccountNumber
			,gl.AccountName
			,gl.AccountType
			,'Vendor Invoice'	AS SrcTransactionType
			,v.ProjectNumber	AS ProjectNumber
			,v.TaskID			AS TaskID
			,v.InvoiceDate		AS SrcTransactionDate
			,v.Quantity			AS SrcQuantity
			,CASE WHEN @WIPRecognizeCostRev = 0 
				THEN v.UnitCost		
				ELSE 
					CASE WHEN v.Quantity = 0 
						THEN v.BillableCost
						ELSE v.BillableCost / v.Quantity 
					END
			END AS SrcUnitCost
			,CASE WHEN @WIPRecognizeCostRev = 0 
				THEN v.TotalCost		
				ELSE v.BillableCost 
			END AS SrcAmount
			,v.VendorName		AS SrcName
			,v.InvoiceNumber			AS SrcDescription
			,co.CompanyName
			,glc.GLCompanyName
			,d.DepartmentName
			,o.OfficeName
	FROM    tTransaction t (NOLOCK)
		INNER JOIN tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vVoucherDetail v (NOLOCK) ON wpd.EntityKey = v.VoucherDetailKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey
	WHERE   t.Entity			= 'WIP'
	AND     t.EntityKey			= @WIPPostingKey
	AND	    wpd.Entity			= 'tVoucherDetail'
	AND     wpd.WIPPostingKey	= @WIPPostingKey
				
	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,mc.MiscCostKey			AS SrcTransactionKey
			,t.ClassKey
			,CASE 
			    WHEN t.ClassKey IS NULL THEN ''
			    ELSE ISNULL(c.ClassName, 'UNKNOWN')
			 END AS ClassName
			,t.Debit
			,t.Credit
			,Case 
			When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
			ELSE Credit - Debit END as Amount
			,gl.AccountNumber
			,gl.AccountName
			,gl.AccountType
			,'Misc Cost'		AS SrcTransactionType
			,p.ProjectNumber	AS ProjectNumber
			,ta.TaskID			AS TaskID
			,mc.ExpenseDate		AS SrcTransactionDate
			,mc.Quantity		AS SrcQuantity
			,mc.UnitCost		AS SrcUnitCost
			,mc.TotalCost		AS SrcAmount
			,i.ItemName			AS SrcName
			,mc.ShortDescription	AS SrcDescription
			,co.CompanyName
			,glc.GLCompanyName
			,d.DepartmentName
			,o.OfficeName
		FROM    tTransaction t (NOLOCK)
		INNER JOIN tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN tMiscCost mc (NOLOCK) ON wpd.EntityKey = mc.MiscCostKey  
		INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
		LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey
	WHERE   t.Entity			= 'WIP'
	AND     t.EntityKey			= @WIPPostingKey
	AND	    wpd.Entity			= 'tMiscCost'
	AND     wpd.WIPPostingKey	= @WIPPostingKey
							
	
		
	RETURN 1
GO
