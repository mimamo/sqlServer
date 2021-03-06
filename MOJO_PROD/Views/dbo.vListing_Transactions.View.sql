USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Transactions]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Transactions]
AS

/*
|| When     Who Rel     What
|| 3/25/13  GWG 10.566  Created
|| 8/08/13  WDF 10.571  (186238) Addded Task Full Name
|| 01/27/15 WDF 10.588  (Abelson Taylor) Added Division and Product ID
|| 01/28/15 GHL 10.588  Added title for Abelson Taylor
|| 02/17/15 GHL 10.590  For Abelson Taylor, light modification to Adjustment Type/Transfer
|| 04/15/15 RLB 10.5.9.1 (253333) added a new field call SourceDescription which matches the old transaction screen data wise
*/

Select 
	p.CompanyKey
	,pt.GLCompanyKey
	,p.CustomFieldKey
	,p.ProjectKey
	
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
	,t.TaskID + ' ' + t.TaskName as [Task Full Name]
	,o.OfficeName as [Office Name]
	,pty.ProjectTypeName as [Project Type]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,pt.TransactionDate
	,DATENAME(Month, pt.TransactionDate) as [Transaction Month]
	,CAST(DATEPART(Year, pt.TransactionDate) AS VARCHAR(4)) as [Transaction Year]
	,pt.Type as [Transaction Type]
	,pt.ItemID as [Item ID]
	,pt.ItemName as [Item Name]
	,pt.Quantity
	,pt.UnitCost as [Unit Cost]
	,pt.TotalCost as [Total Cost]
	,pt.BillableCost as [Billable Amount]
	,case when pt.WriteOff = 1 then pt.TotalCost else 0 end as [Write Off Total Cost]
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
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,wpi.PostingDate as [WIP Posting In Date]
	,wpo.PostingDate as [WIP Posting Out Date]
	,gl.AccountNumber AS [Expense Account Number]
	,gl.AccountName AS [Expense Account Name]
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
    ,case when er.InvoiceLineKey > 0 then
		case when isnull(eri.InvoiceStatus, 0) = 4 then er.AmountBilled else 0 end
    else
		case when isnull(i.InvoiceStatus, 0) = 4 then pt.AmountBilled else 0 end
	end as [Amount Billed Approved]
	,case when er.InvoiceLineKey > 0 then er.DateBilled else pt.DateBilled end as [Date Billed]
	,case when er.InvoiceLineKey > 0 then eri.InvoiceNumber else i.InvoiceNumber end as [Invoice Number]
	,case when er.InvoiceLineKey > 0 then eri.PostingDate else i.PostingDate end as  [Invoice Posting Date]
	,case when er.InvoiceLineKey > 0 then pt.BillableCost - er.AmountBilled else pt.BilledDifference end as [Billed Difference]	
	,CASE 
		WHEN er.InvoiceLineKey IS NOT NULL OR pt.InvoiceLineKey IS NOT NULL THEN 'YES'
		ELSE 'NO'
	END AS [Billed On Invoice]
	,CASE 
		WHEN er.InvoiceLineKey = 0  OR pt.InvoiceLineKey = 0 THEN 'YES'
		ELSE 'NO'
	END AS [Marked as Billed]
	,v.CompanyName as [Vendor Name]
	,v.VendorID + ' ' + v.CompanyName as [Vendor Full Name]
	,cv.DivisionName as [Client Division]
	,cv.DivisionID as [Client Division ID]
	,cp.ProductName as [Client Product]
	,cp.ProductID as [Client Product ID]
	,ct.CompanyTypeName as [Company Type]
	,(SELECT MAX(t2.PlanComplete) FROM tTask t2 (NOLOCK) WHERE t2.ProjectKey = p.ProjectKey) as [Last Task Due Date]
	,pt.DepartmentName AS [Transaction Department]
    ,pt.TranNumber AS [Transaction Number]
    ,pt.EnteredByUser AS [Entered By]
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
    ,pt.TitleName as [Billing Title Name]
    ,pt.SourceDescription as [Source Description]
	,case when pt.AdjustmentType is null then null
	      when pt.AdjustmentType = 0 and pt.TransferOutDate is not null then 'Transfer' -- If TransferOutDate is null, it is not transferred yet 
	      when pt.AdjustmentType = 1 then 'Edited after Posting to WIP'
	      when pt.AdjustmentType = 2 then 'Title Adjustment'
	      when pt.AdjustmentType = 3 then 'Undo Writeoff after Posting out of WIP'
	      else null
	      end as [Adjustment Type]

From vListing_Transactions_Sub pt (nolock)
	inner join tProject p (nolock) on pt.ProjectKey = p.ProjectKey
	Left Outer join tTask t (nolock) on pt.TaskKey = t.TaskKey
	Left Outer Join tProjectType pty (nolock) on p.ProjectTypeKey = pty.ProjectTypeKey
	Left Outer Join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	Left Outer Join tUser am (nolock) on p.AccountManager = am.UserKey
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
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tWIPPosting wpi (nolock) on pt.WIPPostingInKey = wpi.WIPPostingKey
	left outer join tWIPPosting wpo (nolock) on pt.WIPPostingOutKey = wpo.WIPPostingKey
	left outer join tGLAccount gl (nolock) on pt.GLAccountKey = gl.GLAccountKey
	left outer join tClass cla (nolock) on pt.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on pt.GLCompanyKey = glc.GLCompanyKey
	left outer join tExpenseReceipt er (nolock) on pt.Type = 'VOUCHER' AND pt.TranKey = er.VoucherDetailKey
	Left Outer Join tInvoiceLine eril (nolock) on er.InvoiceLineKey = eril.InvoiceLineKey
	Left Outer Join tInvoice eri (nolock) on eril.InvoiceKey =eri.InvoiceKey
	Left Outer Join tCampaign ca (nolock) on p.CampaignKey = ca.CampaignKey
	left outer join tCompany v (nolock) on pt.VendorKey = v.CompanyKey
	left outer join tClientDivision cv (nolock) on p.ClientDivisionKey = cv.ClientDivisionKey
    left outer join tClientProduct cp (nolock) on p.ClientProductKey = cp.ClientProductKey
    left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey

    left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity = 'tItem' and pt.Type <> 'LABOR' and lb.EntityKey = pt.ItemKey
    left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

    left outer join tLayoutBilling lbs (nolock) on p.LayoutKey = lbs.LayoutKey and lbs.Entity = 'tService' and pt.Type = 'LABOR' and lbs.EntityKey = pt.ItemKey
    left outer join tWorkType wts (nolock) on lbs.ParentEntityKey = wts.WorkTypeKey and lbs.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcusts (nolock) on lbs.ParentEntityKey = wtcusts.WorkTypeKey and wtcusts.Entity = 'tProject' and wtcusts.EntityKey = p.ProjectKey
	left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey
GO
