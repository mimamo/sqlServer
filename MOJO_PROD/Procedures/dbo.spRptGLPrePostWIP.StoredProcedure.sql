USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLPrePostWIP]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLPrePostWIP]
	(
	@CompanyKey int,
	@PostingDate smalldatetime,
	@ThroughDate smalldatetime,
	@HeaderGLCompanyKey int,
	@OpeningTransaction tinyint = 0,
	@oErrICTGLCompanyKey int output -- in case of error with ICT GL Companies, get the gl company creating the problem
	)
	 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/11/11 GHL 10.542 (82259) Creation so that we can run the WIP process without inserting in GL
  || 07/06/12 GHL 10.557 Added @oErrICTGLCompanyKey param after adding ICT GL transactions to spGLPostWIP
  || 08/23/12 GHL 10.559 Added IncomeType to #tGL similarly to the change made in spGLPostWIP
  */

	SET NOCOUNT ON

DECLARE @kErrNoWIP				int			SELECT @kErrNoWIP = -1
DECLARE @kErrClosingDate		int			SELECT @kErrClosingDate = -2
DECLARE @kErrWIPAccounts		int			SELECT @kErrWIPAccounts = -3
DECLARE @kErrExpenseAccounts	int			SELECT @kErrExpenseAccounts = -4
DECLARE @kErrSalesAccounts		int			SELECT @kErrSalesAccounts = -5
DECLARE @kErrICTAccounts		int			SELECT @kErrICTAccounts = -6
DECLARE @kErrUnexpected			int			SELECT @kErrUnexpected = @kErrUnexpected

	--1) Create the temp tables that will be populated by spGLPostWIP

CREATE TABLE #tGL (
	RowNum int NOT NULL IDENTITY(1,1),
	GLAccountKey int null,  
	Debit money null,
	Credit money null,
	ClassKey int null,
	ClientKey int null,
	ProjectKey int null,
	GLCompanyKey int null,	
	OfficeKey int null,		
	DepartmentKey int null,
	Reference varchar(100) null, 
	IncludeGLAccount smallint null,
	ItemType smallint null,
	Overhead tinyint null,
	IncomeType int null,
		
	TransactionKey int null
	)

CREATE CLUSTERED INDEX temp_tGL_ind ON #tGL(RowNum)

CREATE TABLE #tWIPPostingDetail(
	WIPPostingKey int null, 
	Entity varchar(100) null,
	EntityKey int null,
	UIDEntityKey uniqueidentifier null,
	TransactionKey int null,
	Amount money null
	)

-- For ICT Inter Company Transactions
CREATE TABLE #tICT (
	GLCompanyKey int null
	,ICTGLCompanyKey int null 
	,InOrOut varchar(5) null -- IN / OUT
	,DueToOrDueFrom varchar(5) null -- DT / DF
	,GLAccountKey int null
	,Debit money null
	,Credit money null
)

	--2) call common WIP routine spGLPostWIP

	declare @RetVal int

	-- 1 means pre post
	exec @RetVal = spGLPostWIP @CompanyKey, @PostingDate, @ThroughDate, '', @HeaderGLCompanyKey, @OpeningTransaction, 1, @oErrICTGLCompanyKey output 
	
	if @RetVal <> 1
		return @RetVal

	update #tGL set TransactionKey = RowNum


	-- 3) clone of spRptWIPPosting
	-- Just replace tTransaction by #tGL
	-- and tWIPPostingDetail by #tWIPPostingDetail
	 
	SELECT  t.TransactionKey
			,v.TimeKey			AS SrcUIDTransactionKey
			,NULL				AS SrcTransactionKey
			,c.ClassKey
			,ISNULL(c.ClassName, 'N/A') AS ClassName
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
	FROM    #tGL t (NOLOCK)
		INNER JOIN #tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vTimeDetail v (NOLOCK) ON wpd.UIDEntityKey = v.TimeKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey

	WHERE	wpd.Entity			= 'tTime'
	
	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,v.ExpenseReceiptKey	AS SrcTransactionKey
			,c.ClassKey
			,ISNULL(c.ClassName, 'N/A') AS ClassName
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
	FROM    #tGL t (NOLOCK)
		INNER JOIN #tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vExpenseReport v (NOLOCK) ON wpd.EntityKey = v.ExpenseReceiptKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey
	WHERE   wpd.Entity			= 'tExpenseReceipt'
	
	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,v.VoucherDetailKey		AS SrcTransactionKey
			,c.ClassKey
			,ISNULL(c.ClassName, 'N/A') AS ClassName
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
			,v.UnitCost			AS SrcUnitCost
			,v.TotalCost		AS SrcAmount
			,v.VendorName		AS SrcName
			,v.InvoiceNumber	AS SrcDescription
			,co.CompanyName
			,glc.GLCompanyName
			,d.DepartmentName
			,o.OfficeName
	FROM    #tGL t (NOLOCK)
		INNER JOIN #tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
		INNER JOIN vVoucherDetail v (NOLOCK) ON wpd.EntityKey = v.VoucherDetailKey
		INNER JOIN tGLAccount as gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass c (NOLOCK) ON t.ClassKey = c.ClassKey
		LEFT OUTER JOIN tCompany co (NOLOCK) on t.ClientKey = co.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on t.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on t.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on t.OfficeKey = o.OfficeKey
	WHERE   wpd.Entity			= 'tVoucherDetail'
				
	UNION
	
	SELECT  t.TransactionKey
			,NULL					AS SrcUIDTransactionKey
			,mc.MiscCostKey			AS SrcTransactionKey
			,c.ClassKey
			,ISNULL(c.ClassName, 'N/A') AS ClassName
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
		FROM    #tGL t (NOLOCK)
		INNER JOIN #tWIPPostingDetail wpd (NOLOCK) ON t.TransactionKey = wpd.TransactionKey
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
	WHERE   wpd.Entity			= 'tMiscCost'
							

	RETURN 1
GO
