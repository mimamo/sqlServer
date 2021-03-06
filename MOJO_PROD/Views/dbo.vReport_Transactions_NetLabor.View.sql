USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Transactions_NetLabor]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Transactions_NetLabor]
AS

/*
|| When     Who Rel     What
|| 10/26/07 CRG 8.4.3.9 (14565) Created a copy of vReport_Transactions showing Net Labor amounts
|| 11/07/07 CRG 8.5     (9205) Modified to get Class from the Transactions rather than the Project.
|| 02/01/08 GHL 8.5     (20472) Added logic for expense receipts on voucher
|| 02/01/08 GHL 8.5     (20431) Changed TotalCost - Should be calculated at Net with Cost Rate
|| 04/23/09 MFT 10.024  (51485) Added Vendor Name, Total Labor Cost, Client Division, Client Product
|| 04/24/09 MFT 10.024	(51139) Added Transaction Department
|| 09/11/09 GHL 10.5     Added Transferred Out
|| 01/19/10 GHL 10.517  (72527) Added Billing Item info
|| 02/18/10 GHL 10.518  (73756) Added Amount Billed Approved
|| 07/13/11 RLB 10.546  (114349) Added Sales Account
|| 07/27/11 RLB 10.546  (111324) Added Campaign Segment and other campaign fields that seem to be missing from this report
|| 09/21/11 RLB 10.548  (119193) Added Project Close Date 
|| 04/23/12 GHL 10.555   Added GLCompanyKey for map/restrict
|| 05/29/12 RLB 10.556  (143884) correctly pulling Total Labor Cost
|| 06/22/12 RLB 10.557  (146849) Added Transaction Month and year
|| 08/17/12 RLB 10.559 (151960) Added Billing Group Code
|| 08/22/12 RLB 10.559  (151545) pulling new TotalCostNet so that labor will be at cost like the expenses
|| 09/28/12 GHL 10.560 Getting now BillingGroupCode from tBillingGroup
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 11/15/12 GWG 10.5.6.2 Added transfer in out dates
|| 01/30/13 GHL 10.5.6.4 (166680) Added Billing Method
|| 11/06/14 WDF 10.5.8.6 (233050) Added Billing Manager
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
|| 01/28/15 GHL 10.5.8.8 Added title for Abelson
|| 03/20/15 WDF 10.5.9.0 (Abelson Taylor) Added AdjustmentType
*/

Select 
	p.CompanyKey
	,pt.GLCompanyKey
	,p.CustomFieldKey
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName  as [Project Full Name]
	,p.StartDate as [Project Start Date]
	,p.CompleteDate as [Project Complete Date]
	,p.CreatedDate as [Project Creation Date]
	,p.ProjectCloseDate as [Project Close Date]
	,bg.BillingGroupCode as [Billing Group Code]
 	,kp1.UserName as [Key People 1]
	,kp2.UserName as [Key People 2]
	,kp3.UserName as [Key People 3]
	,kp4.UserName as [Key People 4]
	,kp5.UserName as [Key People 5]
	,kp6.UserName as [Key People 6]
	,ps.ProjectStatus as [Project Status]
	,Case p.NonBillable When 1 then 'YES' else 'NO' end as [Non Billable Project]
	,Case p.BillingMethod When 1 then 'Time and Material' when 2 then 'Fixed Fee' else 'Retainer' end as [Billing Method]
	,cl.CustomerID as [Client ID]
	,cl.CompanyName as [Client Name]
	,cl.CustomerID + ' ' + cl.CompanyName as [Client Full Name]
	,t.TaskID as [Task ID]
	,t.TaskName as [Task Name]
	,o.OfficeName as [Office Name]
	,pty.ProjectTypeName as [Project Type]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,bm.FirstName + ' ' + bm.LastName as [Billing Manager]
	,pt.TransactionDate
	,DATENAME(Month, pt.TransactionDate) as [Transaction Month]
	,CAST(DATEPART(Year, pt.TransactionDate) AS VARCHAR(4)) as [Transaction Year]
	,pt.Type as [Transaction Type]
	,pt.ItemID as [Item ID]
	,pt.ItemName as [Item Name]
	,pt.Quantity
	,CASE Type
		WHEN 'LABOR' THEN pt.CostRate
		ELSE pt.UnitCost
	END as [Unit Cost]
	,CASE Type
		WHEN 'LABOR' THEN ROUND(pt.Quantity * pt.CostRate, 2) 
		Else pt.TotalCost
	END as [Total Cost]
	,CASE pt.Type WHEN 'LABOR' THEN ROUND(pt.Quantity * pt.CostRate, 2) ELSE 0 END AS [Total Labor Cost]
	,pt.BillableCost as [Billable Amount]
	,case when pt.WriteOff = 1 then pt.TotalCostNet else 0 end as [Write Off Total Cost]
	,case when pt.WriteOff = 1 then pt.BillableCost else 0 end as [Write Off Billable Amount]
	,pt.TransferComment as [Transfer Comment]
	,pt.Comments
	,Case pt.WriteOff When 1 then 'YES' else 'NO' end as [Write Off]
	,Case pt.OnHold When 1 then 'YES' else 'NO' end as [On Hold]
	,Case pt.Status 
		When 1 then 'Not Sent'
		When 2 then 'Sent for Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved'
	end as [Approval Status]
	,wor.ReasonName as [Write Off Reason]
	,rn.Title as [Retainer Name]
	,pbs.ProjectStatus as [Project Billing Status]
	,wpi.PostingDate as [WIP Posting In Date]
	,wpo.PostingDate as [WIP Posting Out Date]
	,gl.AccountNumber AS [Expense Account Number]
	,gl.AccountName AS [Expense Account Name]
	,gl2.AccountNumber AS [Sales Account Number]
	,gl2.AccountName AS [Sales Account Name]
	,pt.DateBilled as [Write Off Date]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,ca.CampaignName as [Campaign Name]
	,ca.CampaignID as [Campaign ID]
	,ca.CampaignName + ' ' + ca.CampaignID as [Campaign Full Name]
	,cs.SegmentName as [Campaign Segment]

	-- All these should change if there is a billed expense receipt  	
	,case when er.InvoiceLineKey > 0 then pt.Description + ' - Prebilled on expense report'  else pt.Description end as [Transaction Description] 
	,case when er.InvoiceLineKey > 0 then er.AmountBilled else pt.AmountBilled end as [Amount Billed] 
	,case when er.InvoiceLineKey > 0 then er.DateBilled else pt.DateBilled end as [Date Billed]
	,case when er.InvoiceLineKey > 0 then eri.InvoiceNumber else i.InvoiceNumber end as [Invoice Number]
	,case when er.InvoiceLineKey > 0 then eri.PostingDate else i.PostingDate end as  [Invoice Posting Date]
	,case when er.InvoiceLineKey > 0 then pt.BillableCost - er.AmountBilled else pt.BilledDifference end as [Billed Difference]	
	,CASE 
		WHEN ISNULL(er.InvoiceLineKey, -1) > 0 THEN 'YES'
		WHEN ISNULL(pt.InvoiceLineKey, -1) > 0 THEN 'YES'
		ELSE 'NO'
	END AS [Billed On Invoice]
	,CASE 
		WHEN ISNULL(er.InvoiceLineKey, -1) = 0 THEN 'YES'
		WHEN ISNULL(pt.InvoiceLineKey, -1) = 0 THEN 'YES'
		ELSE 'NO'
	END AS [Marked as Billed]
	,v.CompanyName as [Vendor Name]
	,v.VendorID + ' ' + v.CompanyName as [Vendor Full Name]
	,cv.DivisionID as [Client Division ID]
	,cv.DivisionName as [Client Division]
	,cp.ProductName as [Client Product]
    ,cp.ProductID as [Client Product ID]
	,pt.DepartmentName AS [Transaction Department]
    ,case when pt.UIDTransferToKey is not null then 'YES'
		  when pt.TransferToKey is not null then 'YES'
		  else 'NO'
	 end as [Transferred Out]
    ,pt.TransferInDate as [Transferred In Date]
    ,pt.TransferOutDate as [Transferred Out Date]
    ,case when p.LayoutKey is null then pt.WorkTypeID 
		  else 
              case when pt.Type = 'LABOR' then wts.WorkTypeID else wt.WorkTypeID end 
     end as [Billing Item ID] 
    ,case when p.LayoutKey is null then pt.WorkTypeName 
		  else 
              case when pt.Type = 'LABOR' then isnull(wtcusts.Subject, wts.WorkTypeName) else isnull(wtcust.Subject, wt.WorkTypeName) end 
     end as [Billing Item Name] 
	,p.ProjectKey
	,pt.TitleName as [Billing Title Name]
	,pt.TitleID as [Billing Title ID]
	,case when pt.AdjustmentType is null then null
	      when pt.AdjustmentType = 0 and pt.TransferOutDate is not null then 'Transfer'
	      when pt.AdjustmentType = 1 then 'Edited after Posting to WIP'
	      when pt.AdjustmentType = 2 then 'Title Adjustment'
	      when pt.AdjustmentType = 3 then 'Undo Writeoff after Posting out of WIP'
	      else null
	      end as [Adjustment Type]
From vProjectTrans pt (nolock)
	inner join tProject p (nolock) on pt.ProjectKey = p.ProjectKey
	Left Outer join tTask t (nolock) on pt.TaskKey = t.TaskKey
	Left Outer Join tProjectType pty (nolock) on p.ProjectTypeKey = pty.ProjectTypeKey
	Left Outer Join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	Left Outer Join tUser am (nolock) on p.AccountManager = am.UserKey
	Left Outer Join tUser bm (nolock) on p.BillingManagerKey = bm.UserKey
	Left Outer Join tInvoiceLine il (nolock) on pt.InvoiceLineKey = il.InvoiceLineKey
	Left Outer Join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	Left outer Join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	Left outer Join tWriteOffReason wor (nolock) on pt.WriteOffReasonKey = wor.WriteOffReasonKey
	left outer join vUserName kp1 (nolock) on p.KeyPeople1 = kp1.UserKey
	left outer join vUserName kp2 (nolock) on p.KeyPeople2 = kp2.UserKey
	left outer join vUserName kp3 (nolock) on p.KeyPeople3 = kp3.UserKey
	left outer join vUserName kp4 (nolock) on p.KeyPeople4 = kp4.UserKey
	left outer join vUserName kp5 (nolock) on p.KeyPeople5 = kp5.UserKey
	left outer join vUserName kp6 (nolock) on p.KeyPeople6 = kp6.UserKey
	left outer join tRetainer rn (nolock) on p.RetainerKey = rn.RetainerKey
	left outer join tProjectStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectStatusKey
	left outer join tWIPPosting wpi (nolock) on pt.WIPPostingInKey = wpi.WIPPostingKey
	left outer join tWIPPosting wpo (nolock) on pt.WIPPostingOutKey = wpo.WIPPostingKey
	left outer join tGLAccount gl (nolock) on pt.GLAccountKey = gl.GLAccountKey
	left outer join tClass cla (nolock) on pt.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on pt.GLCompanyKey = glc.GLCompanyKey
	left outer join tGLAccount gl2 (nolock) on pt.SalesAccountKey = gl2.GLAccountKey
	left outer join tExpenseReceipt er (nolock) on pt.Type = 'VOUCHER' AND pt.TranKey = er.VoucherDetailKey
	Left Outer Join tInvoiceLine eril (nolock) on er.InvoiceLineKey = eril.InvoiceLineKey
	Left Outer Join tInvoice eri (nolock) on eril.InvoiceKey =eri.InvoiceKey
	Left Outer Join tCampaign ca (nolock) on p.CampaignKey = ca.CampaignKey
	left outer join tCompany v (nolock) on pt.VendorKey = v.CompanyKey
	left outer join tClientDivision cv (nolock) on p.ClientDivisionKey = cv.ClientDivisionKey
	left outer join tClientProduct cp (nolock) on p.ClientProductKey = cp.ClientProductKey

    left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity = 'tItem' and pt.Type <> 'LABOR' and lb.EntityKey = pt.ItemKey
    left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

    left outer join tLayoutBilling lbs (nolock) on p.LayoutKey = lbs.LayoutKey and lbs.Entity = 'tService' and pt.Type = 'LABOR' and lbs.EntityKey = pt.ItemKey
    left outer join tWorkType wts (nolock) on lbs.ParentEntityKey = wts.WorkTypeKey and lbs.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcusts (nolock) on lbs.ParentEntityKey = wtcusts.WorkTypeKey and wtcusts.Entity = 'tProject' and wtcusts.EntityKey = p.ProjectKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
GO
