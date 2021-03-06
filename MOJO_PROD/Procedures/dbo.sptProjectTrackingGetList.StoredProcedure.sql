USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTrackingGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTrackingGetList]
 (  
 @CompanyKey int  
 ,@UserKey int  
 ,@ProjectStatusKey int   -- -1 All Active Projects or valid ProjectStatusKey   
 ,@ProjectBillingStatusKey int -- -1 All Billing Status or valid Billing Status  
 ,@BudgetWarning int = 0
 ,@CheckAssignment tinyint = 1
 ,@RestrictToGLCompany tinyint = 0
 ,@GLCompanyKey int = null
 )  
AS -- Encrypt  
  
/*  
|| When     Who Rel   What  
|| 10/02/06 CRG 8.4   Added Budget Calculations to the query for use in the dashboard.    
|| 11/27/06 GHL 8.4   Removed references to tTaskAssignment.    
|| 01/23/07 GHL 8.4   Complete rework because of performance issues   
|| 02/05/07 GHL 8.4   Added reading of new tProject.TotalGross (Calc'ed off line)  
|| 03/02/07 GHL 8.4   Get TotalGross from tProjectRollup instead of tProject.TotalGross   
|| 04/13/07 GHL 8.412 Get ProjectTaskStatus from tProject instead of tTask  
|| 08/15/07 GWG 8.4.3 Added company name, primary contact and phone to the hover  
|| 08/27/07 GWG 8.435 Added contact email  
|| 01/30/08 QMD WMJ 1.0	Intial Release
|| 08/21/08 GWG 10.0006 Added Project Name
|| 8/20/08  CRG 10.0.0.7 Wrapped CampaignName and CompanyName with ISNULL to prevent error in Flex GroupingCollection.
|| 10/20/08 GWG 10.0.1.1 Added Acct Manager
|| 10/20/08 GWG 10.0.1.1 Fixed the warning percentage. needed to be multiplied by 100
|| 03/16/09 QMD 10.5   Removed User Defined Fields
|| 07/28/09 GHL 10.505 Added Project Billing Status because it can be displayed on the project widget
|| 02/24/10 GHL 10.519 (72376) Added Billed Amounts fields (w and w/o taxes)
|| 08/24/10 GWG 10.534 Added Project Percent Complete
|| 11/15/10 RLB 10.538 (77287) Added Division 
|| 08/25/11 GHL 10.547 (119251) Calculating now TotalGross with pr.OpenOrderUnbilled + pr.OrderPrebilled
||                     rather than with pr.OpenOrderGross to match budget screens
|| 09/09/11 RLB 10.548 (120908) Open assignment count take into count PercCompSeparate
|| 02/02/12 MFT 10.552 (129127) Added KeyPerson[1-6] fields
|| 04/11/12 MFT 10.555 Added custom field support, removed obsolete parameters
|| 06/05/12 RLB 10.556 (145468) Fix for right to Access any project with some Restrict To GLCompany Code as well
|| 06/15/12 RLB 10.557 (144566, 144586) Added Client Product and Actual Hours from ProjectRollup
|| 08/09/12 RLB 10.558 Added GL Company option
|| 08/24/12 GHL 10.558 (152523) Using now VoucherOutsideCostsGross rather than VoucherGross for TotalGross because
||                     VoucherGross is just a rough number using tVoucher.BillableCost. Plus in conjunction with
||                     open orders we should use VoucherOutsideCostsGross
|| 11/13/12 WDF 10.562 Added ClientProjectNumber
|| 06/26/13 WDF 10.569 (181054) Added ProjectColor
|| 09/26/14 WDF 10.584 (Abelson Taylor) Added Billing Title and Billing Title Rate Sheet to GetRateFrom
*/  
 SET NOCOUNT ON  
 
IF @CheckAssignment = 1 
BEGIN

	SELECT	p.ProjectKey  
			,ISNULL(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,'') AS ProjectFullName  
			,ISNULL(c.CustomerID,'') + ' - ' + ISNULL(c.CompanyName,'') AS CustomerFullName 
			,ps.ProjectStatus AS ProjectStatus
			,pbs.ProjectBillingStatus AS ProjectBillingStatus
			,pt.ProjectTypeName AS ProjectTypeName
			,p.PercComp as ProjectPercComp
			,ISNULL(ca.CampaignName, '') AS CampaignName
			,u.FirstName + ' ' + u.LastName AS PrimaryContact
			,u.Phone1 
			,u.Email 
			,ISNULL(c.CompanyName, '') AS CompanyName
			,c.Phone
			,ISNULL(p.TaskStatus, 1) AS ProjectTaskStatus
			,(	SELECT	COUNT(*)   
				FROM	tTask t (NOLOCK) INNER JOIN tTaskUser tu (NOLOCK) ON tu.TaskKey = t.TaskKey   
				WHERE	t.ProjectKey = p.ProjectKey  
						AND tu.UserKey = @UserKey  
						AND (t.PercCompSeparate = 1 and tu.ActComplete IS NULL Or  t.PercCompSeparate = 0 and t.ActComplete IS NULL)
					        
				) AS OpenAssignments
			,ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0)  
			+ ISNULL(pr.VoucherOutsideCostsGross, 0) + ISNULL(pr.OpenOrderUnbilled, 0) + ISNULL(pr.OrderPrebilled, 0) 
				AS TotalGross

			-- Budgeted data  
			,p.EstHours AS OriginalBudgetHours -- [Estimate Hours]  
			,p.EstLabor AS  OriginalBudgetLaborGross -- [Estimate Labor]  
			,p.BudgetExpenses AS OriginalBudgetExpenseNet -- [Estimate Expense Net]  
			,p.EstExpenses AS OriginalBudgetExpenseGross -- [Estimate Expense Gross]  
			,p.ApprovedCOHours AS COBudgetHours -- [Approved CO Hours]  
			,p.ApprovedCOLabor AS COBudgetLaborGross -- [Approved CO Labor]  
			,p.ApprovedCOExpense AS COBudgetExpenseGross -- [Approved CO Expense Gross]  
			,p.EstHours + p.ApprovedCOHours AS CurrentBudgetHours -- [Estimate Total Hours]  
			,p.EstLabor + p.ApprovedCOLabor AS CurrentBudgetLaborGross -- [Estimate Total Labor]  
			,p.EstExpenses + p.ApprovedCOExpense AS CurrentBudgetExpenseGross --[Estimate Total Gross Expense]  
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense AS TotalBudget -- [Estimate Total]  
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense 
				+ ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) AS TotalBudgetwTaxes --New field  

			,pr.BilledAmount
			,pr.BilledAmountNoTax
			,pr.Hours as ActualHours
		
			,p.StatusNotes AS ProjectStatusNote  
			,p.DetailedNotes AS ProjectStatusDescription  
			,p.StartDate AS ProjectStartDate 
			,p.CompleteDate AS ProjectDueDate  
			,p.CreatedDate AS CreatedDate  

			,CASE p.GetRateFrom   
				WHEN 9 THEN 'Billing Title'
				WHEN 10 THEN 'Billing Title Rate Sheet'
				WHEN 1 THEN 'Client'  
				WHEN 2 THEN 'Project'  
				WHEN 3 THEN 'Project User'  
				WHEN 4 THEN 'Service'  
				WHEN 5 THEN 'Service Rate Sheet'  
				WHEN 6 THEN 'Task'  
				END AS GetLaborRateFrom  
			,CASE p.GetMarkupFrom   
				WHEN 1 THEN 'Client'  
				WHEN 2 THEN 'Project'  
				WHEN 3 THEN 'Item'  
				WHEN 4 THEN 'Item Rate Sheet'  
				WHEN 5 THEN 'Task'  
				END AS GetMarkupFrom  

			,CASE NonBillable WHEN 1 THEN 'YES' ELSE 'NO' END AS NonBillableProject  
			,CASE Closed When 1 THEN 'YES' ELSE 'NO' END AS ClosedProject
			,p.ProjectNumber
			,p.ProjectName
			,p.ProjectColor
			,cd.DivisionName
			,cp.ProductName
			,am.FirstName + ' ' + am.LastName as AccountManagerName
			,p.ClientProjectNumber
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as TestEst
			,ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) as TestCost
			,CASE 
				WHEN (p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) = 0 THEN 1
				WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) )  > 
						p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense THEN 3
				WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
						(p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) * 100 >= @BudgetWarning THEN 2
				ELSE 1
				END AS FinancialStatusImage
			,ISNULL(kp1.FirstName, '') + ' ' + ISNULL(kp1.LastName, '') AS KeyPerson1
			,ISNULL(kp2.FirstName, '') + ' ' + ISNULL(kp2.LastName, '') AS KeyPerson2
			,ISNULL(kp3.FirstName, '') + ' ' + ISNULL(kp3.LastName, '') AS KeyPerson3
			,ISNULL(kp4.FirstName, '') + ' ' + ISNULL(kp4.LastName, '') AS KeyPerson4
			,ISNULL(kp5.FirstName, '') + ' ' + ISNULL(kp5.LastName, '') AS KeyPerson5
			,ISNULL(kp6.FirstName, '') + ' ' + ISNULL(kp6.LastName, '') AS KeyPerson6
			,cf.*
	FROM	tProject p (NOLOCK) 
			INNER JOIN tAssignment a (NOLOCK)  ON p.ProjectKey = a.ProjectKey  
			INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey  
			LEFT  JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey   
			LEFT  JOIN tCampaign ca (nolock)  ON p.CampaignKey = ca.CampaignKey   
			LEFT  JOIN tCompany c (nolock)   ON p.ClientKey = c.CompanyKey  
			LEFT  JOIN tUser u (nolock)   ON p.BillingContact = u.UserKey  
			LEFT  JOIN tUser am (nolock)   ON p.AccountManager = am.UserKey  
			LEFT  JOIN tProjectRollup pr (nolock)  ON p.ProjectKey = pr.ProjectKey  
			LEFT  JOIN tProjectBillingStatus pbs (nolock) ON p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
			LEFT  JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
			LEFT  JOIN tClientProduct cp (nolock) on p.ClientProductKey = cp.ClientProductKey
			LEFT JOIN tUser kp1 (nolock) ON p.KeyPeople1 = kp1.UserKey
			LEFT JOIN tUser kp2 (nolock) ON p.KeyPeople2 = kp2.UserKey
			LEFT JOIN tUser kp3 (nolock) ON p.KeyPeople3 = kp3.UserKey
			LEFT JOIN tUser kp4 (nolock) ON p.KeyPeople4 = kp4.UserKey
			LEFT JOIN tUser kp5 (nolock) ON p.KeyPeople5 = kp5.UserKey
			LEFT JOIN tUser kp6 (nolock) ON p.KeyPeople6 = kp6.UserKey
			LEFT JOIN #tCustomFields cf (nolock) ON p.CustomFieldKey = cf.CustomFieldKey
	WHERE	p.CompanyKey = @CompanyKey  
			AND p.Deleted = 0  
			AND a.UserKey = @UserKey  
			AND ( 
					(@ProjectStatusKey = -1 AND p.Active = 1)  
					OR  
					(p.ProjectStatusKey = @ProjectStatusKey)  
				)  
			AND (@ProjectBillingStatusKey = -1 OR p.ProjectBillingStatusKey = @ProjectBillingStatusKey)
			AND (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)
				
END
ELSE
BEGIN
	SELECT	p.ProjectKey  
			,ISNULL(p.ProjectNumber,'') + ' - ' + ISNULL(p.ProjectName,'') AS ProjectFullName  
			,ISNULL(c.CustomerID,'') + ' - ' + ISNULL(c.CompanyName,'') AS CustomerFullName 
			,ps.ProjectStatus AS ProjectStatus
			,pbs.ProjectBillingStatus AS ProjectBillingStatus
			,pt.ProjectTypeName AS ProjectTypeName
			,p.PercComp as ProjectPercComp
			,ISNULL(ca.CampaignName, '') AS CampaignName
			,u.FirstName + ' ' + u.LastName AS PrimaryContact
			,u.Phone1 
			,u.Email 
			,ISNULL(c.CompanyName, '') AS CompanyName
			,c.Phone
			,ISNULL(p.TaskStatus, 1) AS ProjectTaskStatus
			,(	SELECT	COUNT(*)   
				FROM	tTask t (NOLOCK) INNER JOIN tTaskUser tu (NOLOCK) ON tu.TaskKey = t.TaskKey   
				WHERE	t.ProjectKey = p.ProjectKey  
						AND tu.UserKey = @UserKey  
						AND (t.PercCompSeparate = 1 and tu.ActComplete IS NULL Or  t.PercCompSeparate = 0 and t.ActComplete IS NULL)
					        
				) AS OpenAssignments
			,ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0)  
			+ ISNULL(pr.VoucherOutsideCostsGross, 0) + ISNULL(pr.OpenOrderUnbilled, 0) + ISNULL(pr.OrderPrebilled, 0) 
				AS TotalGross

			-- Budgeted data  
			,p.EstHours AS OriginalBudgetHours -- [Estimate Hours]  
			,p.EstLabor AS  OriginalBudgetLaborGross -- [Estimate Labor]  
			,p.BudgetExpenses AS OriginalBudgetExpenseNet -- [Estimate Expense Net]  
			,p.EstExpenses AS OriginalBudgetExpenseGross -- [Estimate Expense Gross]  
			,p.ApprovedCOHours AS COBudgetHours -- [Approved CO Hours]  
			,p.ApprovedCOLabor AS COBudgetLaborGross -- [Approved CO Labor]  
			,p.ApprovedCOExpense AS COBudgetExpenseGross -- [Approved CO Expense Gross]  
			,p.EstHours + p.ApprovedCOHours AS CurrentBudgetHours -- [Estimate Total Hours]  
			,p.EstLabor + p.ApprovedCOLabor AS CurrentBudgetLaborGross -- [Estimate Total Labor]  
			,p.EstExpenses + p.ApprovedCOExpense AS CurrentBudgetExpenseGross --[Estimate Total Gross Expense]  
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense AS TotalBudget -- [Estimate Total]  
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense 
				+ ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) AS TotalBudgetwTaxes --New field  

			,pr.BilledAmount
			,pr.BilledAmountNoTax
			,pr.Hours as ActualHours
		
			,p.StatusNotes AS ProjectStatusNote  
			,p.DetailedNotes AS ProjectStatusDescription  
			,p.StartDate AS ProjectStartDate 
			,p.CompleteDate AS ProjectDueDate  
			,p.CreatedDate AS CreatedDate  

			,CASE p.GetRateFrom   
				WHEN 9 THEN 'Billing Title'
				WHEN 10 THEN 'Billing Title Rate Sheet'
				WHEN 1 THEN 'Client'  
				WHEN 2 THEN 'Project'  
				WHEN 3 THEN 'Project User'  
				WHEN 4 THEN 'Service'  
				WHEN 5 THEN 'Service Rate Sheet'  
				WHEN 6 THEN 'Task'  
				END AS GetLaborRateFrom  
			,CASE p.GetMarkupFrom   
				WHEN 1 THEN 'Client'  
				WHEN 2 THEN 'Project'  
				WHEN 3 THEN 'Item'  
				WHEN 4 THEN 'Item Rate Sheet'  
				WHEN 5 THEN 'Task'  
				END AS GetMarkupFrom  

			,CASE NonBillable WHEN 1 THEN 'YES' ELSE 'NO' END AS NonBillableProject  
			,CASE Closed When 1 THEN 'YES' ELSE 'NO' END AS ClosedProject
			,p.ProjectNumber
			,p.ProjectName
			,p.ProjectColor
			,cd.DivisionName
			,cp.ProductName
			,am.FirstName + ' ' + am.LastName as AccountManagerName
			,p.ClientProjectNumber
			,p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as TestEst
			,ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) as TestCost
			,CASE 
				WHEN (p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) = 0 THEN 1
				WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) )  > 
						p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense THEN 3
				WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
						(p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) * 100 >= @BudgetWarning THEN 2
				ELSE 1
				END AS FinancialStatusImage
			,ISNULL(kp1.FirstName, '') + ' ' + ISNULL(kp1.LastName, '') AS KeyPerson1
			,ISNULL(kp2.FirstName, '') + ' ' + ISNULL(kp2.LastName, '') AS KeyPerson2
			,ISNULL(kp3.FirstName, '') + ' ' + ISNULL(kp3.LastName, '') AS KeyPerson3
			,ISNULL(kp4.FirstName, '') + ' ' + ISNULL(kp4.LastName, '') AS KeyPerson4
			,ISNULL(kp5.FirstName, '') + ' ' + ISNULL(kp5.LastName, '') AS KeyPerson5
			,ISNULL(kp6.FirstName, '') + ' ' + ISNULL(kp6.LastName, '') AS KeyPerson6
			,cf.*
	FROM	tProject p (NOLOCK)  
			INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey  
			LEFT  JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey   
			LEFT  JOIN tCampaign ca (nolock)  ON p.CampaignKey = ca.CampaignKey   
			LEFT  JOIN tCompany c (nolock)   ON p.ClientKey = c.CompanyKey  
			LEFT  JOIN tUser u (nolock)   ON p.BillingContact = u.UserKey  
			LEFT  JOIN tUser am (nolock)   ON p.AccountManager = am.UserKey  
			LEFT  JOIN tProjectRollup pr (nolock)  ON p.ProjectKey = pr.ProjectKey  
			LEFT  JOIN tProjectBillingStatus pbs (nolock) ON p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
			LEFT  JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
			LEFT  JOIN tClientProduct cp (nolock) on p.ClientProductKey = cp.ClientProductKey
			LEFT JOIN tUser kp1 (nolock) ON p.KeyPeople1 = kp1.UserKey
			LEFT JOIN tUser kp2 (nolock) ON p.KeyPeople2 = kp2.UserKey
			LEFT JOIN tUser kp3 (nolock) ON p.KeyPeople3 = kp3.UserKey
			LEFT JOIN tUser kp4 (nolock) ON p.KeyPeople4 = kp4.UserKey
			LEFT JOIN tUser kp5 (nolock) ON p.KeyPeople5 = kp5.UserKey
			LEFT JOIN tUser kp6 (nolock) ON p.KeyPeople6 = kp6.UserKey
			LEFT JOIN #tCustomFields cf (nolock) ON p.CustomFieldKey = cf.CustomFieldKey
	WHERE	p.CompanyKey = @CompanyKey  
			AND p.Deleted = 0  
			AND ( 
					(@ProjectStatusKey = -1 AND p.Active = 1)  
					OR  
					(p.ProjectStatusKey = @ProjectStatusKey)  
				)  
			AND (@ProjectBillingStatusKey = -1 OR p.ProjectBillingStatusKey = @ProjectBillingStatusKey)
			AND (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)
			AND (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 OR isnull(p.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)))
END

 RETURN 1
GO
