USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectStatus]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE               VIEW [dbo].[vProjectStatus]
AS

  /*
  || When     Who Rel   What
  || 12/13/06 GHL 8.4   Added restriction on TaskType = 2 for TaskStatus 
  || 04/13/07 GHL 8.4   Reading tProject.TaskStatus instead of tTask.TaskStatus 
  ||                                 + join with tProjectRollup
  || 01/13/10 GHL 10.516 Changed formatting of client and project + added rollup fields
  || 09/21/12 GHL 10.560 (154566) Added ExpenseGrossOrderPrebilled to show on the Project Billing Worksheet
  ||                     instead of ExpenseGross to make it more similar to the budget screens  
  */

SELECT 
	isnull(c.CustomerID + ' \ ','') + ISNULL(p.ProjectNumber + ' \ ','') + ISNULL(LEFT(p.ProjectName,15),'') AS ClientProject,
	isnull(c.CustomerID + ' - ','') +  + isnull(c.CompanyName,'') as CustomerFullName,
	isnull(rtrim(p.ProjectNumber)+' - ','') + isnull(p.ProjectName,'') as ProjectFullName,
	c.CompanyName,
	c.CustomerID,
	
	ps.ProjectStatus, 
	ps.DisplayOrder, 
	u.FirstName + ' ' + u.LastName AS AccountManagerName,
	LEFT(ISNULL(u.FirstName, ''), 1) + LEFT(ISNULL(u.MiddleName, ''), 1) + LEFT(ISNULL(u.LastName, ''), 1) AS AccountManagerInitials, 
	pt.ProjectTypeName,
	ca.CampaignName,
	ISNULL(p.TaskStatus, 1) as ProjectTaskStatus,
	ISNULL(roll.Hours, 0) as ActHours,
	
	roll.AdvanceBilled,
	roll.AdvanceBilledOpen,
	roll.BilledAmount,
	roll.BilledAmountNoTax,
	
	roll.LaborGross,
	roll.MiscCostGross,
	roll.ExpReceiptGross,
	roll.VoucherGross,
	roll.MiscCostGross + roll.ExpReceiptGross + roll.VoucherGross As ExpenseGross,
	roll.MiscCostGross + roll.ExpReceiptGross + roll.VoucherGross + roll.OrderPrebilled As ExpenseGrossOrderPrebilled,
	
	roll.OpenOrderGross,    -- this is calculated unbilled
	
	roll.LaborUnbilled,
	roll.MiscCostUnbilled,
	roll.ExpReceiptUnbilled,
	roll.VoucherUnbilled,
	roll.MiscCostUnbilled + roll.ExpReceiptUnbilled + roll.VoucherUnbilled As ExpenseUnbilled,
	
	p.* 
	
FROM 
	tProject p (nolock) 
	INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
    LEFT OUTER JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey 
	LEFT OUTER JOIN tCampaign ca (nolock) ON p.CampaignKey = ca.CampaignKey 
	LEFT OUTER JOIN tUser u (nolock) ON p.AccountManager = u.UserKey 
	LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
Where
	p.Deleted = 0
GO
