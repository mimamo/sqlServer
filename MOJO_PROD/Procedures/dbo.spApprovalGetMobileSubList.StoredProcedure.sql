USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spApprovalGetMobileSubList]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApprovalGetMobileSubList]
	(
	@UserKey int,
	@Section varchar(50)
	)
AS --Encrypt

  /*
  || When       Who Rel      What
  || 02/15/2011 MFT 10.5.4.1 Added AllDayEvent to tCalendar selects
  || 02/22/2011 MFT 10.5.4.1 Added Entity to all selects
  || 06/22/2011 GWG 10.5.4.5 Added AttendeeKey so the update could find the attendee's key.
  || 10/11/2012 GWG 10.5.6.0 Modified how the backup approver is taken into account
  || 11/15/2012 GWG 10.5.6.2 Took off the requirement for an active project for reviews and deliverables (reversed this for reviews, not deliverables)
  || 08/21/2013 MFT 10.5.7.1 Added CreatedByKey to PO/IO/BO gets (187765)
  || 08/26/2013 RLB 10.5.7.1 Added billingmanagerkey check for billing worksheet approval
  || 10/11/2013 RLB 10.5.7.3 (192443) Added email to Po for sending of emails to po createdby
  || 12/26/2013 WDF 10.5.7.5 (198697) Added BillingManagerKey check specific to Retainers for Billing Worksheet Approval
  */
  
SET NOCOUNT ON

Declare @NotifyEmail varchar(200), @CompanyKey int, @ClientVendorLogin tinyint
Declare @POApprovalLimit as money, @IOApprovalLimit as money, @BCApprovalLimit as money
Declare @Administrator int, @SecurityGroupKey int, @CanApproveBillingWorksheet int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
,@POApprovalLimit = ISNULL(POLimit, 0)
,@IOApprovalLimit = ISNULL(IOLimit, 0)
,@BCApprovalLimit = ISNULL(BCLimit, 0) 
,@ClientVendorLogin = ISNULL(ClientVendorLogin, 0)
,@Administrator = ISNULL(Administrator, 0)
,@SecurityGroupKey = SecurityGroupKey 
from tUser (nolock) Where UserKey = @UserKey

if @Administrator = 1
	select @CanApproveBillingWorksheet = 1
else
begin
	if exists (select 1 
				from tRightAssigned ra (nolock)
	            inner join tRight r (nolock) on ra.RightKey = r.RightKey
				where ra.EntityKey = @SecurityGroupKey
				and   ra.EntityType = 'Security Group'
				and   r.RightID = 'billingeditinvoice')
					select @CanApproveBillingWorksheet = 1
	else
					select @CanApproveBillingWorksheet = 0
end

if @ClientVendorLogin = 1
	Select @POApprovalLimit = -999, @IOApprovalLimit = -999, @BCApprovalLimit = -999 

Select @NotifyEmail = Email
From
	tUser u (nolock)
	Inner join tPreference p (nolock) on u.UserKey = p.NotifyExpenseReport
Where
	p.CompanyKey = @CompanyKey

if @Section = 'Inv' OR @Section is null
BEGIN
	Select
		'tInvoice' AS Entity
		,i.InvoiceKey As EntityKey
		,i.InvoiceDate
		,i.InvoiceNumber	
		,i.PostingDate, i.InvoiceTotalAmount, c.CustomerID, c.CompanyName
		,case when p.ProjectNumber is null then null else p.ProjectNumber + ' - ' + p.ProjectName end as ProjectFullName
	from tInvoice i (nolock)
		inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		left join tProject p (nolock) on i.ProjectKey = p.ProjectKey
	Where
		i.InvoiceStatus = 2 and
		i.ApprovedByKey = @UserKey
	Order By InvoiceDate
END

 if @Section = 'TimeSheet'
BEGIN
	 SELECT
	 	'tTimeSheet' AS Entity
	 	,ts.TimeSheetKey As EntityKey
		,ts.StartDate, ts.EndDate
		,u.FirstName + ' ' + u.LastName As UserName
	
		,(Select SUM(ActualHours) From tTime (nolock) Where ts.TimeSheetKey = tTime.TimeSheetKey) AS TotalHours, ts.StartDate, ts.EndDate
	
		,ts.TimeSheetKey , u.FirstName, u.LastName, u.Email
	 FROM tTimeSheet ts (NOLOCK)
	   INNER JOIN tUser u (NOLOCK) ON ts.UserKey = u.UserKey
	   LEFT OUTER JOIN tUser app (NOLOCK) on u.TimeApprover = app.UserKey
	 WHERE ( u.TimeApprover = @UserKey OR app.BackupApprover = @UserKey )
	  AND  ts.Status = 2
	 ORDER BY u.LastName, ts.StartDate
END

 if @Section = 'ExpReport'
BEGIN
	 SELECT 
		'tExpenseEnvelope' AS Entity,
		ee.ExpenseEnvelopeKey As EntityKey,
		ee.EnvelopeNumber,u.FirstName + ' ' + u.LastName as UserName,
		ee.StartDate, ee.EndDate
		,(Select SUM(er.ActualCost) from tExpenseReceipt er (nolock) Where ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey)  AS TotalCost
		
	 FROM tExpenseEnvelope ee (NOLOCK)
	   INNER JOIN tUser u (NOLOCK) ON ee.UserKey = u.UserKey
	   LEFT OUTER JOIN tUser app (NOLOCK) on u.ExpenseApprover = app.UserKey
	 WHERE ( u.ExpenseApprover = @UserKey OR app.BackupApprover = @UserKey )
	 AND  ee.Status = 2
	 ORDER BY ee.EnvelopeNumber
END

 if @Section = 'ArtReview'
BEGIN

	SELECT
		 'tApproval' AS Entity,
		 tApproval.ApprovalKey As EntityKey,
		 tProject.ProjectNumber + '-' + tProject.ProjectName As ProjectFullName,
		 tApproval.ApprovalKey, 
		 tApproval.Subject, 
		 tApproval.DueDate,
		 tApproval.DateSent
	FROM tApproval (nolock) 
		INNER JOIN tApprovalList (nolock) ON tApproval.ApprovalKey = tApprovalList.ApprovalKey
		inner join tProject (nolock) on tApproval.ProjectKey = tProject.ProjectKey
	WHERE 
		((
		tApproval.ApprovalOrderType = 2 AND			-- Send In Order
		tApproval.ActiveApprover = @UserKey AND 
		tApprovalList.UserKey = @UserKey AND 
		tApproval.Status = 1 
	
	 ) OR (
		tApproval.ApprovalOrderType = 1 AND
		tApproval.ActiveApprover IS NULL AND			-- Send At Once 
		tApprovalList.UserKey = @UserKey AND
		tApproval.Status = 1 
		)) 
	AND
		tApprovalList.Completed = 0 AND
		tProject.Active = 1
	ORDER BY 
		tApproval.DueDate
END

 if @Section = 'PO'
BEGIN
		
	SELECT
		'tPurchaseOrderPO' AS Entity,
		po.PurchaseOrderKey As EntityKey,
		po.PODate,
		po.PurchaseOrderNumber,
		c.VendorID + ' - ' + c.CompanyName AS VendorFullName, 
		po.PODate, 
		po.OrderedBy, 
		po.ApprovedByKey,
		po.CreatedByKey,
		tUser.Email,
		SUM(pod.TotalCost) AS NetCost, 
		SUM(pod.BillableCost) AS GrossCost
	FROM 
		tPurchaseOrder po (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON po.VendorKey = c.CompanyKey
		LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tUser (NOLOCK) on po.CreatedByKey = tUser.UserKey
	WHERE 
		po.Status = 2 and
		po.POKind = 0 and
		po.CompanyKey = @CompanyKey
	GROUP BY 
		po.PurchaseOrderKey, 
		po.PurchaseOrderNumber, 
		c.VendorID, c.CompanyName, 
		po.ApprovedByKey,
		po.CreatedByKey,
		po.PODate, 
		po.OrderedBy,
		tUser.Email
	Having ISNULL(SUM(pod.TotalCost), 0) <= @POApprovalLimit and 
	(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

	ORDER BY 
		po.PurchaseOrderNumber
	
END

 if @Section = 'IO'
BEGIN
	SELECT
		'tPurchaseOrderIO' AS Entity,
		po.PurchaseOrderKey As EntityKey,
		po.PODate,
		po.PurchaseOrderNumber,
		c.VendorID + ' - ' + c.CompanyName AS VendorFullName, 
		po.PODate, 
		po.OrderedBy, 
		po.ApprovedByKey,
		po.CreatedByKey,
		tUser.Email,
		SUM(pod.TotalCost) AS NetCost, 
		SUM(pod.BillableCost) AS GrossCost
	FROM 
		tPurchaseOrder po (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON po.VendorKey = c.CompanyKey
		LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tUser (NOLOCK) on po.CreatedByKey = tUser.UserKey
	WHERE 
		po.Status = 2 and
		po.POKind = 1 and
		po.CompanyKey = @CompanyKey
	GROUP BY 
		po.PurchaseOrderKey, 
		po.PurchaseOrderNumber, 
		c.VendorID, c.CompanyName, 
		po.PODate, 
		po.OrderedBy,
		po.CreatedByKey,
		po.ApprovedByKey,
		tUser.Email
	Having ISNULL(SUM(pod.TotalCost), 0) <= @IOApprovalLimit and 
	(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

	ORDER BY 
		po.PurchaseOrderNumber
END

 if @Section = 'BO'
BEGIN

	SELECT
		'tPurchaseOrderBC' AS Entity,
		po.PurchaseOrderKey As EntityKey,
		po.PODate,
		po.PurchaseOrderNumber,
		c.VendorID + ' - ' + c.CompanyName AS VendorFullName, 
		po.PODate, 
		po.OrderedBy, 
		po.ApprovedByKey,
		po.CreatedByKey,
		tUser.Email,
		SUM(pod.TotalCost) AS NetCost, 
		SUM(pod.BillableCost) AS GrossCost
	FROM 
		tPurchaseOrder po (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON po.VendorKey = c.CompanyKey
		LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tUser (NOLOCK) on po.CreatedByKey = tUser.UserKey
	WHERE 
		po.Status = 2 and
		po.POKind = 2 and
		po.CompanyKey = @CompanyKey
	GROUP BY 
		po.PurchaseOrderKey, 
		po.PurchaseOrderNumber, 
		c.VendorID, c.CompanyName, 
		po.PODate, 
		po.OrderedBy,
		po.CreatedByKey,
		po.ApprovedByKey,
		tUser.Email
	Having ISNULL(SUM(pod.TotalCost), 0) <= @BCApprovalLimit and 
	(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

	ORDER BY 
		po.PurchaseOrderNumber
END

 if @Section = 'Voucher'
BEGIN

	SELECT
		'tVoucher' AS Entity
		,v.VoucherKey As EntityKey
		,v.InvoiceDate 
		,v.InvoiceNumber
		,v.VendorID + ' - ' + v.VendorName as VendorFullName
		,v.VoucherTotal
		,v.ProjectFullName
		from vVoucher v (NOLOCK)
	WHERE 
		v.Status = 2 AND 
		v.ApprovedByKey = @UserKey
	ORDER BY 
		v.VendorID, v.InvoiceNumber
END

 if @Section = 'ProjRequest'
BEGIN

	SELECT
			'tRequest' AS Entity,
			r.RequestKey As EntityKey,
			asu.DateActivated as SortDate,
			r.RequestID,
			r.RequestedBy,
			asu.DateActivated,
			asu.DueDate,
			c.CustomerID,
			c.CompanyName,
			rd.RequestName
		FROM tApprovalStep step (nolock) 
			inner join tApprovalStepUser asu on step.ApprovalStepKey = asu.ApprovalStepKey
			inner join tRequest r on step.EntityKey = r.RequestKey
			inner join tRequestDef rd on r.RequestDefKey = rd.RequestDefKey
			left outer join tCompany c on r.ClientKey = c.CompanyKey
		WHERE
		step.Entity = 'ProjectRequest' and
		asu.AssignedUserKey = @UserKey and
		asu.ActiveUser = 1
		Order By
			asu.DueDate
END

 if @Section = 'Est'
BEGIN	
			
		SELECT
			'tEstimate' AS Entity
			,'Project' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
	UNION ALL
	
		SELECT
			'tEstimate' AS Entity
			,'Opportunity' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.Subject, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tLead p (NOLOCK) ON e.LeadKey = p.LeadKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
	UNION ALL
	
		SELECT
			'tEstimate' AS Entity
			,'Campaign' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.CampaignID, '') + '-' + ISNULL(p.CampaignName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tCampaign p (NOLOCK) ON e.CampaignKey = p.CampaignKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
END

 if @Section = 'CO'
BEGIN

		SELECT
			'tEstimateCO' AS Entity
			,'Project' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
	UNION ALL
	
		SELECT
			'tEstimateCO' AS Entity
			,'Opportunity' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.Subject, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tLead p (NOLOCK) ON e.LeadKey = p.LeadKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
	UNION ALL
	
		SELECT
			'tEstimateCO' AS Entity
			,'Campaign' as Source
			,e.EstimateKey As EntityKey
			,ISNULL(p.CampaignID, '') + '-' + ISNULL(p.CampaignName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tCampaign p (NOLOCK) ON e.CampaignKey = p.CampaignKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		
END

 if @Section = 'BWR'
BEGIN
			
Select
		'tBilling' AS Entity
		,b.BillingKey As EntityKey 
		,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
		,c.CustomerID + ' - ' +  c.CompanyName as ClientName
		,u.FirstName + ' ' + u.LastName as AccountManager
		,b.DueDate
		,Case b.BillingMethod
			When 1 then 'Time & Materials'
			When 2 then 'Fixed Fee'
			When 3 then 'Retainer'
			else 'Master Worksheet' end as MethodName
		,ISNULL(LaborTotal, 0) + ISNULL(ExpenseTotal, 0) AS ToBill	
		,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) 
			as BudgetAmount
		,(Select Sum(TotalAmount) from tInvoiceLine (nolock)
			inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey
			Where tInvoiceLine.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
From
	tBilling b (NOLOCK) 
	left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
Where
	b.CompanyKey = @CompanyKey and
	b.Approver = @UserKey and
	b.Status in (1, 3)
Order By b.BillingID

END

 if @Section = 'BWA'
BEGIN

Select
		'tBillingApprove' AS Entity
		,b.BillingKey As EntityKey 
		,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
		,c.CustomerID + ' - ' +  c.CompanyName as ClientName
		,u.FirstName + ' ' + u.LastName as AccountManager
		,b.DueDate
		,Case b.BillingMethod
			When 1 then 'Time & Materials'
			When 2 then 'Fixed Fee'
			When 3 then 'Retainer'
			else 'Master Worksheet' end as MethodName
		,ISNULL(LaborTotal, 0) + ISNULL(ExpenseTotal, 0) AS ToBill	
		,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) 
			as BudgetAmount
		,(Select Sum(TotalAmount) from tInvoiceLine (nolock)
			inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey
			Where tInvoiceLine.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
From
	tBilling b (NOLOCK) 
	left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
	left outer join tRetainer r (nolock) on b.EntityKey = r.RetainerKey
Where
	b.CompanyKey = @CompanyKey and
	b.Status = 2 and
	--b.Approver = @UserKey and     -- Anybody who has right = billingeditinvoice can approve
 	@ClientVendorLogin = 0 and
	@CanApproveBillingWorksheet = 1 and 
	1 = CASE WHEN (b.BillingMethod <> 3 AND (p.BillingManagerKey IS NULL or p.BillingManagerKey = @UserKey)) THEN 1
             WHEN (b.BillingMethod  = 3 AND (r.BillingManagerKey IS NULL or r.BillingManagerKey = @UserKey)) THEN 1
             ELSE 0 
        END
Order By b.BillingID	

END

 if @Section = 'MyMeeting'
BEGIN

	SELECT distinct 
		'myMeeting' AS Entity
		,c.CalendarKey As EntityKey
		,c.EventStart
		,c.EventEnd
		,c.Subject
		,c.Location
		,c.AllDayEvent
	FROM tCalendar c (nolock)
	INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
	INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
	WHERE c.CompanyKey = @CompanyKey
	and ca.Entity <> 'Resource' 
	and ca.Entity <> 'Group'
	and ca.Status = 1
	and c.Deleted <> 1
	and ca.EntityKey = @UserKey
	and c.EventStart >= GETUTCDATE()
	Order By c.EventStart

END

 if @Section = 'OtherMeeting'
BEGIN

	SELECT distinct 
		'otherMeeting' AS Entity
		,c.CalendarKey As EntityKey
		,c.EventStart
		,c.EventEnd
		,c.Subject
		,c.Location
		,c.AllDayEvent
		,ca.EntityKey as AttendeeKey
	FROM tCalendar c (nolock)
	INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
	INNER JOIN tCMFolderSecurity fs (nolock) ON ca.CMFolderKey = fs.CMFolderKey
	INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey

	WHERE c.CompanyKey = @CompanyKey
	AND ((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
			OR
			(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
	AND	fs.CanAdd = 1
	and ca.Entity <> 'Resource' 
	and ca.Entity <> 'Group'
	and ca.Status = 1
	and u.UserKey <> @UserKey
	and c.Private = 0
	and c.Deleted <> 1
	and c.EventStart >= GETUTCDATE()
	Order By c.EventStart

END
RETURN 1
GO
