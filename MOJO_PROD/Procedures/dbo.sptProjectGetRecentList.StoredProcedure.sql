USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetRecentList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetRecentList]
 (  
	@UserKey int
 )  
AS -- Encrypt  
  
/*  
|| When     Who Rel			What  
|| 09/03/14 MAS 10.5.8.3	Created for the new app
*/  
 SET NOCOUNT ON  

	SELECT TOP 10 p.*	
	,CASE ISNULL(c.CustomerID,'')
			WHEN '' THEN ISNULL(ISNULL(c.CompanyName,''), '')
			ELSE 
				CASE ISNULL(c.CompanyName,'')
					WHEN '' THEN ISNULL(c.CustomerID,'')
					ELSE c.CustomerID + ' - ' + c.CompanyName
				END
			END AS CustomerFullName
	,ISNULL(p.PercComp, 0) as ProjectPercComp	
	,ISNULL(p.TaskStatus, 1) AS ProjectTaskStatus
	,CASE 
		WHEN (p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) = 0 THEN 1
		WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) )  > 
				p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense THEN 3
		WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
				(p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) * 100 >= 80 THEN 2 -- @BudgetWarning = 80%  TODO: make a company default
		ELSE 1
	END AS FinancialStatusImage
	,CASE
		WHEN (ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) = 0 THEN 0
		ELSE (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
				(ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) * 100 
	END AS FinancialStatusPerc
	FROM tProject p (nolock)
	INNER JOIN tAppHistory ah (nolock) on ah.ActionKey = p.ProjectKey and ah.ActionID = 'projects.production.myProjects'
	LEFT  JOIN tProjectRollup pr (nolock)  ON p.ProjectKey = pr.ProjectKey 
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey 
	WHERE 
		ah.UserKey = @UserKey

	ORDER BY ah.DateAdded DESC
GO
