USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGetApprovalTranCount]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGetApprovalTranCount]

	(
		@UserKey int
	)

AS

  /*
  || When     Who Rel      What
  || 03/09/07 GHL 8.4      Added NOLOCK after tVoucher   
  || 04/30/08 QMD 1.0      Added code to fix PO, IO, BC counts                     
  || 05/01/08 GHL 1.0      Added inner join with tExpenseReceipt because there is no need to approve if no receipts  
  || 05/02/08 GHL 8.509    Added CompanyKey to where clause on POs 
  || 06/05/08 CRG 8.5.1.2  (27670) Changed joins on purchase order counts so that it will count PO's with no lines  
  || 06/10/08 CRG 8.5.1.3  (28378) Added GROUP BY clauses in PO counts so that the HAVING clause works properly.
  || 06/11/08 CRG 8.5.1.3  (28378) Removed GROUP BY because it was causing a problem.  
  ||                       Rewrote the query so that we don't need the HAVING clause to check the PO Approval limits.
  || 06/11/08 GWG 10.0.0.2 Added MyMeetingCount and OtherMeetingCount
  || 09/22/08 GWG 10.0.0.9 Added Request for Quote count
  || 12/12/08 GWG 10.0.1.4 (41938) Removed the Distinct from the other peoples meeting counts because it would not count the meeting if 2 people were invited (would count it as 1)
  || 7/10/09  CRG 10.5.0.4 (57096) Modified Other Peoples' Meetings query to use the tCMFolderSecurity table now rather than tCalendarUser
  || 10/05/09 RLB 10.5.1.2 (64692)Made the DA count the Same as on the Approval sp
  || 10/20/09 GWG 10.5.1.2 (66369) Changed other peoples meetings to not show private and exclude this persons meetings.
  || 07/05/10 GHL 10.5.3.1 (83992) Added b.Approver = @UserKey in where clause to Billing Worksheets to Approve
  ||                       Make it similar to spApprovalGetList
  || 07/20/10 GHL 10.5.3.2 (85367) Anybody who has billingeditinvoice right can approve a Billing worksheet
  ||                       So remove b.Approver = @UserKey but add @CanApproveBillingWorksheet = 1 to where clause 
  || 11/17/10 RLB 10.5.3.8 (94792) Added active project filter to Digital Art Review count
  || 09/28/11 GHL 10.5.4.8 Separated vouchers from credit card charges
  || 01/16/11 GWG 10.5.5.2 Added the deliverable approval count
  || 10/11/12 GWG 10.5.6.0 Modified how the backup approver is taken into account
  || 11/15/12 GWG 10.5.6.2 Took off the requirement for an active project for reviews and deliverables (reversed this for reviews, not deliverables)
  || 07/30/13 KMC 10.5.7.0 (184557) Update the credit card approvals count to use the new right purch_approvecreditcardcharge (60403)
  || 08/15/13 GWG 10.5.7.0 Fixed the join for credit card charges
  || 08/26/13 RLB 10.5.7.1 Added billingmanagerkey check for billing worksheet approval
  || 12/26/13 WDF 10.5.7.5 (198697) Added BillingManagerKey check specific to Retainers for Billing Worksheet Approval
  || 03/27/14 RLB 10.5.7.8 (210983) add check for right for enhancement (187663)
  */

DECLARE @POApprovalLimit AS MONEY, @IOApprovalLimit AS MONEY, @BCApprovalLimit AS MONEY, @CompanyKey INT, @SecurityGroupKey INT,@ClientVendorLogin tinyint
Declare @Administrator int,  @CanApproveBillingWorksheet int,  @CanApproveVoucher int

SELECT	@POApprovalLimit = ISNULL(POLimit, 0)
		,@IOApprovalLimit = ISNULL(IOLimit, 0)
		,@BCApprovalLimit = ISNULL(BCLimit, 0) 
		,@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
		,@Administrator = ISNULL(Administrator, 0)
		,@SecurityGroupKey = SecurityGroupKey
		,@ClientVendorLogin = ISNULL(ClientVendorLogin, 0)
FROM	tUser (NOLOCK) 
WHERE	UserKey = @UserKey

if exists(Select 1 from tUser Where UserKey = @UserKey and ClientVendorLogin = 1)
	Select @POApprovalLimit = -999, @IOApprovalLimit = -999, @BCApprovalLimit = -999 
  
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

	if exists (select 1 
				from tRightAssigned ra (nolock)
	            inner join tRight r (nolock) on ra.RightKey = r.RightKey
				where ra.EntityKey = @SecurityGroupKey
				and   ra.EntityType = 'Security Group'
				and   r.RightID = 'purch_approvemyprojectvoucher')
					select @CanApproveVoucher = 1
	else
					select @CanApproveVoucher = 0
end

Select
	(SELECT Count(*) FROM tTimeSheet ts (NOLOCK) inner join tUser u (NOLOCK) on ts.UserKey = u.UserKey 
	    LEFT OUTER JOIN tUser app (NOLOCK) on u.TimeApprover = app.UserKey
		Where ( u.TimeApprover = @UserKey OR app.BackupApprover = @UserKey )
		AND  ts.Status = 2) as TimeSheetCount
	,(SELECT Count(*) FROM tExpenseEnvelope en (NOLOCK) 
	   INNER JOIN tUser u (NOLOCK) ON en.UserKey = u.UserKey
	   LEFT OUTER JOIN tUser app (NOLOCK) on u.ExpenseApprover = app.UserKey
		WHERE ( u.ExpenseApprover = @UserKey OR app.BackupApprover = @UserKey )
		AND  en.Status = 2
		AND  EXISTS (SELECT 1 FROM tExpenseReceipt er (NOLOCK)
				WHERE en.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey)
		) as ExpenseReportCount
	,(
		SELECT	COUNT(*)
		FROM	tPurchaseOrder po (NOLOCK)
		LEFT JOIN 
				(SELECT pod2.PurchaseOrderKey, ISNULL(SUM(pod2.TotalCost), 0) AS TotalCost
				FROM	tPurchaseOrderDetail pod2 (NOLOCK)
				INNER JOIN tPurchaseOrder po2 (NOLOCK) ON pod2.PurchaseOrderKey = po2.PurchaseOrderKey
				WHERE	po2.CompanyKey = @CompanyKey
				GROUP BY pod2.PurchaseOrderKey) pod ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		WHERE	POKind = 0 AND Status = 2
		AND     CompanyKey = @CompanyKey
		AND		(ISNULL(ApprovedByKey, 0) = 0 OR ISNULL(ApprovedByKey, 0) = @UserKey)
		AND		ISNULL(pod.TotalCost, 0) <= @POApprovalLimit
	  ) AS PurchaseOrderCount
	,(	
		SELECT	COUNT(*)
		FROM	tPurchaseOrder po (NOLOCK)
		LEFT JOIN 
				(SELECT pod2.PurchaseOrderKey, ISNULL(SUM(pod2.TotalCost), 0) AS TotalCost
				FROM	tPurchaseOrderDetail pod2 (NOLOCK)
				INNER JOIN tPurchaseOrder po2 (NOLOCK) ON pod2.PurchaseOrderKey = po2.PurchaseOrderKey
				WHERE	po2.CompanyKey = @CompanyKey
				GROUP BY pod2.PurchaseOrderKey) pod ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		WHERE	POKind = 1 AND Status = 2
		AND     CompanyKey = @CompanyKey
		AND		(ISNULL(ApprovedByKey, 0) = 0 OR ISNULL(ApprovedByKey, 0) = @UserKey)
		AND		ISNULL(pod.TotalCost, 0) <= @IOApprovalLimit
      ) AS IOCount
	,(		
		SELECT	COUNT(*)
		FROM	tPurchaseOrder po (NOLOCK)
		LEFT JOIN 
				(SELECT pod2.PurchaseOrderKey, ISNULL(SUM(pod2.TotalCost), 0) AS TotalCost
				FROM	tPurchaseOrderDetail pod2 (NOLOCK)
				INNER JOIN tPurchaseOrder po2 (NOLOCK) ON pod2.PurchaseOrderKey = po2.PurchaseOrderKey
				WHERE	po2.CompanyKey = @CompanyKey
				GROUP BY pod2.PurchaseOrderKey) pod ON po.PurchaseOrderKey = pod.PurchaseOrderKey
		WHERE	POKind = 2 AND Status = 2
		AND     CompanyKey = @CompanyKey
		AND		(ISNULL(ApprovedByKey, 0) = 0 OR ISNULL(ApprovedByKey, 0) = @UserKey)
		AND		ISNULL(pod.TotalCost, 0) <= @BCApprovalLimit
	  ) AS BCCount
	,(
		SELECT Count(*)
		FROM 
			tQuoteReply qr (nolock) 
		WHERE
			qr.ContactKey = @UserKey and
			qr.Status < 3
	  ) AS QuoteCount

	,(SELECT Count(*) FROM tVoucher (nolock) 
		WHERE tVoucher.Status = 2 
		AND ISNULL(tVoucher.CreditCard, 0) = 0
		AND isnull(tVoucher.CreditCard, 0) = 0
		AND (tVoucher.ApprovedByKey = @UserKey
			OR
				(	@CanApproveVoucher = 1 
					and
					tVoucher.ProjectKey in (
											SELECT
												ProjectKey
											FROM
												tRight r (nolock)
												INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey AND r.RightID = 'purch_approvemyprojectvoucher'
												INNER JOIN tSecurityGroup sg (nolock) ON ra.EntityKey = sg.SecurityGroupKey AND ra.EntityType = 'Security Group'
												INNER JOIN tUser u (nolock) ON sg.SecurityGroupKey = u.SecurityGroupKey
												INNER JOIN tAssignment a (nolock) ON u.UserKey = a.UserKey
											WHERE
												a.UserKey = @UserKey
											)
				)
			)
	)as VoucherCount
	,(SELECT Count(*) FROM tVoucher (nolock) 
		WHERE tVoucher.Status = 2 
		AND tVoucher.CompanyKey = @CompanyKey
		AND isnull(tVoucher.CreditCard, 0) = 1
		AND (tVoucher.ApprovedByKey = @UserKey OR (tVoucher.ApprovedByKey IS NULL AND @UserKey in (SELECT UserKey
																									  FROM tUser u (NOLOCK)
																										INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey
																									 WHERE ra.EntityType = 'Security Group' AND RightKey = 60403)))
		) as CreditCardChargeCount

	,(Select Count(*) from tInvoice i (nolock) inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey Where i.InvoiceStatus = 2 and i.ApprovedByKey = @UserKey) as InvoiceCount
	
	,(select count(*) from tEstimate (nolock) 
	  where ChangeOrder = 1 
	  and ((InternalApprover = @UserKey and InternalStatus = 2)
			Or (ExternalApprover = @UserKey and ExternalStatus = 2)) ) as ChangeOrderCount
	
	,(select count(*) from tEstimate (nolock) 
	  where ChangeOrder = 0 
	  and ((InternalApprover = @UserKey and InternalStatus = 2)
			Or (ExternalApprover = @UserKey and ExternalStatus = 2)) ) as EstimateCount
	
	,(select count(*) from tApproval (nolock) 
		INNER JOIN tApprovalList (nolock) ON tApproval.ApprovalKey = tApprovalList.ApprovalKey
		INNER JOIN tProject (nolock) on tApproval.ProjectKey = tProject.ProjectKey
		WHERE 
		((
		tApproval.ApprovalOrderType = 2 AND 
		tApproval.ActiveApprover = @UserKey AND 
			tApprovalList.UserKey = @UserKey AND 
			tApproval.Status = 1
		) OR (
		tApproval.ApprovalOrderType = 1 AND
		tApproval.ActiveApprover IS NULL AND 
			tApprovalList.UserKey = @UserKey AND
			tApproval.Status = 1 )) AND
			tApprovalList.Completed = 0 AND tProject.Active = 1) as ProjectApprovalCount

	,(select count(*) from tBilling (nolock) Where Approver = @UserKey and Status in (1, 3)) as BillingCount
	
	,(select count(*) from tBilling b (nolock)
		inner join tUser u (nolock) on b.CompanyKey = u.CompanyKey
		left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey 
		left outer join tRetainer r (nolock) on b.EntityKey = r.RetainerKey
		Where u.UserKey = @UserKey and Status = 2
		--and b.Approver = @UserKey 
		and @ClientVendorLogin = 0
		and @CanApproveBillingWorksheet = 1 
		and 1 = CASE WHEN (b.BillingMethod <> 3 AND (p.BillingManagerKey IS NULL or p.BillingManagerKey = @UserKey)) THEN 1
                     WHEN (b.BillingMethod  = 3 AND (r.BillingManagerKey IS NULL or r.BillingManagerKey = @UserKey)) THEN 1
                     ELSE 0 
                END
		) as AccountingBillingCount

	,(select count(*) from tApprovalStep step (nolock)
			inner join tApprovalStepUser asu (nolock) on step.ApprovalStepKey = asu.ApprovalStepKey
	
		WHERE
			step.Entity = 'ProjectRequest' and
			asu.AssignedUserKey = @UserKey and
			asu.ActiveUser = 1) as ProjectRequestCount
	 ,(SELECT count(distinct c.CalendarKey)
		 FROM tCalendar c (nolock), tCalendarAttendee ca (nolock), tUser u (nolock)
		 WHERE ca.Entity <> 'Resource' 
		 and ca.Entity <> 'Group'
		 and ca.EntityKey = u.UserKey
		 and c.CalendarKey = ca.CalendarKey
		 and ca.Status = 1
		 and c.Deleted <> 1
		 and ca.EntityKey = @UserKey
		 and c.EventStart >= GETUTCDATE() ) as MyMeetingCount


	 ,(SELECT count(c.CalendarKey)
			FROM tCalendar c (nolock)
			INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
			INNER JOIN tCMFolderSecurity fs (nolock) ON ca.CMFolderKey = fs.CMFolderKey
			INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
			WHERE c.CompanyKey = @CompanyKey
			AND ((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
					OR
					(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
			AND	fs.CanAdd = 1
			AND ca.Entity <> 'Resource' 
			AND ca.Entity <> 'Group'
			AND ca.Status = 1
			AND c.Private = 0
			AND u.UserKey <> @UserKey
			AND c.Deleted <> 1
			AND c.EventStart >= GETUTCDATE()) as OtherMeetingCount
	,(SELECT count(*) 
		FROM	tApprovalStepUser asu (NOLOCK) 
		INNER JOIN tApprovalStep a (NOLOCK) ON asu.ApprovalStepKey = a.ApprovalStepKey
		INNER JOIN tReviewRound rr (NOLOCK) ON rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
		INNER JOIN tReviewDeliverable rd (NOLOCK) ON rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey
		WHERE	asu.AssignedUserKey = @UserKey and asu.ActiveUser = 1 and a.ActiveStep = 1) as DeliverableCount
GO
