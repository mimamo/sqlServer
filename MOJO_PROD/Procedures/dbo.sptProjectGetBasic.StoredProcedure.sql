USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetBasic]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetBasic]
 @ProjectKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 03/01/07 RTC 8.4.0.3 Added TimeActive flag from Project Status table (#8362)
|| 10/19/07 BSH 8.5     Company & Office are locked once a PO is created. 
|| 11/1/07  CRG 8.5     Added ProjectBillingStatus
|| 01/20/10 GHL 10.517  (72908) Server running slow. sptProjectGetBasic @ProjectKey = 0 in my SQL trace
||                       Added check of ProjectKey before looking up in trans
|| 08/27/10 GHL 10.534  Added GLCompanyID, ClassName for flex lookups
|| 12/07/10 GHL 10.538  Added contact name + LayoutName to default on flex client invoice
|| 09/12/12 GHL 10.560  Added Billing Group Code for HMI request
|| 12/05/13 GHL 10.575  Added BillAt info from client for PO Flex screen
*/

Declare @LockCompany int
Select @LockCompany = 0

Declare @Invoiced int
Select @Invoiced = 0

Declare @HasApprovedEstimates int
Select @HasApprovedEstimates = 0

if @ProjectKey > 0
begin
	if exists(Select 1 from tInvoiceLine (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
		
	if exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
		
	if exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey > 0)
		Select @LockCompany = 1
		
	if exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1

	if exists(Select 1 from tBilling (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1

	Select @Invoiced = count(*) from tInvoiceLine (nolock) where ProjectKey = @ProjectKey

	Select @HasApprovedEstimates =  COUNT(*) FROM tEstimate (NOLOCK) 
	WHERE ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) 
	Or (isnull(ExternalApprover, 0) = 0 
	and  InternalStatus = 4)) 
	AND ProjectKey = @ProjectKey
	
	Select @Invoiced = isnull(@Invoiced, 0), @HasApprovedEstimates = isnull(@HasApprovedEstimates, 0)  
end 	
	
  SELECT pr.*
	 ,@HasApprovedEstimates AS HasApprovedEstimates
     ,@Invoiced as Invoiced
     ,ISNULL(cl.CompanyName,'') as ClientName
     ,isnull(CustomerID,'') as CustomerID
     ,cl.ItemMarkup as ClientItemMarkup
     ,cl.IOCommission as ClientIOCommission
     ,cl.BCCommission as ClientBCCommission
	 ,cl.IOBillAt as ClientIOBillAt
	 ,cl.BCBillAt as ClientBCBillAt
	 ,ps.ProjectStatus
     ,ps.Locked as StatusLocked
     ,ps.TimeActive
     ,r.RequestID
	 ,ca.CampaignID
	 ,am.FirstName + ' ' + am.LastName as AccountManagerName
	 ,lockedby.FirstName + ' ' + lockedby.LastName as ScheduleLockedByName
	 ,bcu.FirstName + ' ' + bcu.LastName as BillingContactName
	 ,glc.GLCompanyID
	 ,glc.GLCompanyName
	 ,o.OfficeID
	 ,o.OfficeName
     ,c.ClassID
	 ,c.ClassName
     ,@LockCompany as LockCompany
     ,isnull(pbs.ProjectBillingStatus, '') as ProjectBillingStatus
	 ,l.LayoutName
	 ,bg.BillingGroupCode as BillingGroup -- could not return bg.BillingGroupCode because of pr.BillingGroupCode (needed for conversion) 
    FROM tProject pr (nolock)
    inner join tProjectStatus ps (nolock) on pr.ProjectStatusKey = ps.ProjectStatusKey
    left outer join tCompany cl (nolock) on pr.ClientKey = cl.CompanyKey
    left join tProjectBillingStatus pbs (nolock) on pr.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
    left outer join tClass c (nolock) on pr.ClassKey = c.ClassKey
    left outer join tOffice o (nolock) on pr.OfficeKey = o.OfficeKey
    left outer join tGLCompany glc (nolock) on pr.GLCompanyKey = glc.GLCompanyKey
    left outer join tUser lockedby (nolock) on pr.ScheduleLockedByKey = lockedby.UserKey
    left outer join tUser am (nolock) on pr.AccountManager = am.UserKey
    left outer join tCampaign ca (nolock) on pr.CampaignKey = ca.CampaignKey
    left outer join tRequest r (nolock) on pr.RequestKey = r.RequestKey
    left outer join tUser bcu (nolock) on pr.BillingContact = bcu.UserKey
	left outer join tLayout l (nolock) on pr.LayoutKey = l.LayoutKey
	left outer join tBillingGroup bg (nolock) on pr.BillingGroupKey = bg.BillingGroupKey  

  WHERE
   ProjectKey = @ProjectKey
  
 RETURN 1
GO
