USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spAppApprovalGetList]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAppApprovalGetList]
	(
	@UserKey int,
	@Entity varchar(25)
	)
AS --Encrypt

  /*
  || 12/02/14 MAS 10.5.8.7 Created for Platinum, to allow individual approval sections.
 */
  
SET NOCOUNT ON

Declare @NotifyEmail varchar(200), @CompanyKey int, @ClientVendorLogin tinyint
Declare @POApprovalLimit as money, @IOApprovalLimit as money, @BCApprovalLimit as money
Declare @Administrator int, @SecurityGroupKey int, @CanApproveBillingWorksheet int, @CanApproveVoucher int

 /*
  When making changes to this SP, double check that you may have to make changes to sptDashboardGetApprovalTranCount
  and spApprovalGetList as well to support legacy WMJ (Flex)
 */
 
--- Boilerplate stuff
Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
,@POApprovalLimit = ISNULL(POLimit, 0)
,@IOApprovalLimit = ISNULL(IOLimit, 0)
,@BCApprovalLimit = ISNULL(BCLimit, 0)
,@ClientVendorLogin = ISNULL(ClientVendorLogin, 0)
,@Administrator = ISNULL(Administrator, 0)
,@SecurityGroupKey = SecurityGroupKey
,@CanApproveBillingWorksheet = 0
,@CanApproveVoucher = 0
from tUser (nolock) Where UserKey = @UserKey

IF @Administrator = 1
	SELECT @CanApproveBillingWorksheet = 1, @CanApproveVoucher = 1
ELSE
	BEGIN
		SELECT
			@CanApproveBillingWorksheet = 1
		FROM
			tRight r (nolock)
			INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey
		WHERE
			ra.EntityKey = @SecurityGroupKey AND
			ra.EntityType = 'Security Group' AND
			r.RightID = 'billingeditinvoice'
		
		SELECT
			@CanApproveVoucher = 1
		FROM
			tRight r (nolock)
			INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey
		WHERE
			ra.EntityKey = @SecurityGroupKey AND
			ra.EntityType = 'Security Group' AND
			r.RightID = 'purch_approvemyprojectvoucher'
	END

if @ClientVendorLogin = 1
	Select @POApprovalLimit = -999, @IOApprovalLimit = -999, @BCApprovalLimit = -999 

Select @NotifyEmail = Email
From
	tUser u (nolock)
	Inner join tPreference p (nolock) on u.UserKey = p.NotifyExpenseReport
Where
	p.CompanyKey = @CompanyKey


--- tInvoice
if (ISNULL(@Entity, 'tInvoice') = 'tInvoice')
	Begin
		Select 'Invoices' As Type		-- Friendly Name used in Grouping and visible on grid
			,'tInvoice' As Entity
			,i.InvoiceKey As EntityKey
			,i.InvoiceDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,i.InvoiceNumber As Reference	
			,0 AS Selected
			
			,i.InvoiceDate, i.InvoiceTotalAmount, c.CustomerID, c.CompanyName as ClientName
			,ISNULL(ProjectNumber, '') AS ProjectNumber
		from tInvoice i (nolock)
			inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			left join tProject p (nolock) on i.ProjectKey = p.ProjectKey
		Where
			i.InvoiceStatus = 2 and
			i.ApprovedByKey = @UserKey
		Order By InvoiceDate
	End

--- tTimeSheet
if (ISNULL(@Entity, 'tTimeSheet') = 'tTimeSheet')
	Begin
		 SELECT 'Time Sheets' As Type
			,'tTimeSheet' As Entity
			,ts.TimeSheetKey As EntityKey
			,ts.StartDate as SortDate
			,1 as ShowCheckBox
			,ApprovalComments 
			,u.FirstName + ' ' + u.LastName As Reference
			,0 AS Selected
			
			,(Select SUM(ActualHours) From tTime (nolock) Where ts.TimeSheetKey = tTime.TimeSheetKey) AS TotalHours, ts.StartDate, ts.EndDate
			
			,ts.TimeSheetKey , u.FirstName, u.LastName, u.Email
		 FROM tTimeSheet ts (NOLOCK)
		   INNER JOIN tUser u (NOLOCK) ON ts.UserKey = u.UserKey
		   LEFT OUTER JOIN tUser app (NOLOCK) on u.TimeApprover = app.UserKey
		 WHERE ( u.TimeApprover = @UserKey OR app.BackupApprover = @UserKey )
		  AND  ts.Status = 2
		 ORDER BY u.LastName, ts.StartDate
	End
 
--- tExpenseEnvelope
if (ISNULL(@Entity, 'tExpenseEnvelope') = 'tExpenseEnvelope')
	Begin
		 SELECT 'Expense Reports' As Type
			,'tExpenseEnvelope' As Entity
			,ee.ExpenseEnvelopeKey As EntityKey
			,ee.StartDate as SortDate
			,1 as ShowCheckBox
			,ApprovalComments As ApprovalComments 
			,ee.EnvelopeNumber As Reference
			,0 AS Selected

			,(Select SUM(er.ActualCost) from tExpenseReceipt er (nolock) Where ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey)  AS TotalCost,  
			u.FirstName, u.LastName, ee.StartDate, ee.EndDate
			,ee.ExpenseEnvelopeKey, u.Email, @NotifyEmail as NotifyEmail
			,u.FirstName + ' ' + u.LastName as UserName
		 FROM tExpenseEnvelope ee (NOLOCK)
		   INNER JOIN tUser u (NOLOCK) ON ee.UserKey = u.UserKey
		   LEFT OUTER JOIN tUser app (NOLOCK) on u.ExpenseApprover = app.UserKey
		 WHERE ( u.ExpenseApprover = @UserKey OR app.BackupApprover = @UserKey )
		 AND  ee.Status = 2
		 ORDER BY ee.EnvelopeNumber
	End

--- tApproval
if (ISNULL(@Entity, 'tApproval') = 'tApproval')
	Begin
		SELECT 'Digital Art To Review' As Type
			,'tApproval' As Entity
			,tApproval.ApprovalKey As EntityKey
			,tApproval.DateSent as SortDate
			,0 as ShowCheckBox
			,NULL As ApprovalComments 
			,tProject.ProjectNumber + '-' + tProject.ProjectName As Reference
			,0 AS Selected
		 ,1 as HideCheckBox
		 ,tProject.ProjectNumber,
		 tProject.ProjectKey,
		 tProject.ProjectName,
		 tApproval.ApprovalKey, 
		 tApproval.Subject, 
		 tApproval.Description, 
		 tApproval.Status,
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
	End
 
--- tReviewDeliverable
if (ISNULL(@Entity, 'tReviewDeliverable') = 'tReviewDeliverable')
	Begin
		SELECT	p.ProjectNumber + ' - ' + p.ProjectName as Project
			, 'tReviewDeliverable' as Entity
			, rd.ReviewDeliverableKey as EntityKey
			, rd.DeliverableName
			, rr.RoundName
			, rr.ReviewRoundKey
			, isnull(asu.DueDate, getdate()) as DueDate
			, a.TimeZoneIndex
		FROM	tApprovalStepUser asu (NOLOCK) 
		INNER JOIN tApprovalStep a (NOLOCK) ON asu.ApprovalStepKey = a.ApprovalStepKey
		INNER JOIN tReviewRound rr (NOLOCK) ON rr.ReviewRoundKey = a.EntityKey AND a.Entity = 'tReviewRound'
		INNER JOIN tReviewDeliverable rd (NOLOCK) ON rd.ReviewDeliverableKey = rr.ReviewDeliverableKey
		INNER JOIN tProject p (NOLOCK) on rd.ProjectKey = p.ProjectKey

		WHERE	asu.AssignedUserKey = @UserKey and asu.ActiveUser = 1 and a.ActiveStep = 1
		--TODO add datesent restriction
		ORDER BY p.ProjectNumber, DeliverableName
	End


--- tQuoteReply
if (ISNULL(@Entity, 'tQuoteReply') = 'tQuoteReply')
	Begin
		SELECT 'Quote Replies' As Type
		,'tQuoteReply' AS Entity
		,qr.QuoteReplyKey as EntityKey
		,q.QuoteDate as SortDate
		,0 as ShowCheckBox
		,NULL As ApprovalComments 
		,q.QuoteNumber As Reference
 		,0 AS Selected
		,q.QuoteNumber,
		q.SendRepliesTo,
		q.MultipleQty,
		q.Quote1,
		q.Quote2,
		q.Quote3,
		q.Quote4,
		q.Quote5,
		q.Quote6,						
		qr.*,
		c.CompanyName,
		c.VendorID,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Email,
		'StatusName' =CASE qr.Status
			WHEN 1 THEN 'No Reply'
			WHEN 2 THEN 'Reply Not Finalized'
			WHEN 3 THEN 'Reply Completed'
		END,				
		(Select Sum(TotalCost) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal,
		(Select Sum(isnull(TotalCost2, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal2,
		(Select Sum(isnull(TotalCost3, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal3,
		(Select Sum(isnull(TotalCost4, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal4,
		(Select Sum(isnull(TotalCost5, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal5,
		(Select Sum(isnull(TotalCost6, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal6

		FROM 
			tQuoteReply qr (nolock) 
			INNER JOIN tCompany c (nolock) ON qr.VendorKey = c.CompanyKey 
			LEFT OUTER JOIN tUser u (nolock) ON qr.ContactKey = u.UserKey
			INNER JOIN tQuote q (nolock) ON qr.QuoteKey = q.QuoteKey
		WHERE
			qr.ContactKey = @UserKey and
			qr.Status < 3
		ORDER BY
			q.QuoteNumber,
			qr.QuoteReplyNumber
	End
				
--- tPurchaseOrderPO		
if (ISNULL(@Entity, 'tPurchaseOrderPO') = 'tPurchaseOrderPO')
	Begin
		SELECT 'Purchase Orders' AS Type
			,'tPurchaseOrder' As Entity
			,po.PurchaseOrderKey As EntityKey
			,po.PODate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,po.PurchaseOrderNumber As Reference
			,0 AS Selected
			
			,c.VendorID, c.CompanyName AS VendorName, 
			po.PODate, 
			po.OrderedBy, 
			po.CreatedByKey,
			po.ApprovedByKey,
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
			po.PODate, 
			po.OrderedBy,
			po.CreatedByKey,
			po.ApprovedByKey,
			tUser.Email
		Having ISNULL(SUM(pod.TotalCost), 0) <= @POApprovalLimit and 
		(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

		ORDER BY 
			po.PurchaseOrderNumber
	End
	
--- tPurchaseOrderIO
if (ISNULL(@Entity, 'tPurchaseOrderIO') = 'tPurchaseOrderIO')
	Begin
		SELECT 'Insertion Orders' AS Type
			,'tPurchaseOrder' As Entity
			,po.PurchaseOrderKey As EntityKey
			,po.PODate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,po.PurchaseOrderNumber As Reference
			,0 AS Selected

			,c.VendorID, c.CompanyName AS VendorName, 
			po.PODate, 
			po.OrderedBy, 
			po.CreatedByKey,
			po.ApprovedByKey,
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
	End

--- tPurchaseOrderBC
if (ISNULL(@Entity, 'tPurchaseOrderBC') = 'tPurchaseOrderBC')
	Begin
		SELECT 'Broadcast Orders' AS Type
			,'tPurchaseOrder' As Entity
			,po.PurchaseOrderKey As EntityKey
			,po.PODate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,po.PurchaseOrderNumber As Reference
			,0 AS Selected

			,c.VendorID, c.CompanyName AS VendorName, 
			po.PODate, 
			po.OrderedBy, 
			po.CreatedByKey,
			po.ApprovedByKey,
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
	End

--- tVoucher	
if (ISNULL(@Entity, 'tVoucher') = 'tVoucher')
	Begin
		IF @UserKey is null
			SELECT 'Vendor Invoices' AS Type
				,'tVoucher' As Entity
				,v.VoucherKey As EntityKey
				,v.InvoiceDate as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,v.InvoiceNumber As Reference
				,0 AS Selected
			
				,v.VendorID, v.VendorName
				,v.InvoiceDate
				,v.VoucherTotal
				,v.VoucherDescription
					    
				from vVoucher v (NOLOCK)
			WHERE 
				v.Status = 4 AND 
				v.Posted = 0 AND
				v.CompanyKey = @CompanyKey AND
				isnull(v.CreditCard, 0) = 0
			ORDER BY 
				v.VendorID, v.InvoiceNumber
		ELSE
			SELECT 'Vendor Invoices' AS Type
				,'tVoucher' As Entity
				,v.VoucherKey As EntityKey
				,v.InvoiceDate as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,v.InvoiceNumber As Reference
				,0 AS Selected
			
				,v.VendorID, v.VendorName
				,v.InvoiceDate
				,v.VoucherTotal
				,v.VoucherDescription
					    
				from vVoucher v (NOLOCK)
			WHERE
				v.Status = 2 AND 
				ISNULL(v.CreditCard, 0) = 0 AND
				(
					ISNULL(v.ApprovedByKey, 0) = @UserKey OR
					(
						@CanApproveVoucher = 1 AND
						v.ProjectKey IN
						(
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
			ORDER BY 
				v.VendorID, v.InvoiceNumber
	End

--- tRequest
if (ISNULL(@Entity, 'tRequest') = 'tRequest')
	Begin
		SELECT 'Project Requests' AS Type
				,'tRequest' As Entity
				,r.RequestKey As EntityKey
				,asu.DateActivated as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,r.RequestID As Reference
				,0 AS Selected
				,r.CustomFieldKey
				,r.RequestKey,
				r.RequestID,
				r.RequestedBy,
				r.NotifyEmail,
				asu.DateActivated,
				asu.DueDate,
				step.Instructions,
				asu.Comments,
				c.CustomerID,
				c.CompanyName,
				rd.RequestName,
				r.Subject
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
	End
			
--- tEstimate
if (ISNULL(@Entity, 'tEstimate') = 'tEstimate')
	Begin			
		SELECT 'Estimates' As Type 
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.ProjectKey
			,p.ProjectNumber
			,p.ProjectName
			,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		UNION ALL
	
		SELECT 'Estimates' As Type 
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.LeadKey
			,''
			,p.Subject
			,ISNULL(p.Subject, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tLead p (NOLOCK) ON e.LeadKey = p.LeadKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		UNION ALL
	
		SELECT 'Estimates' As Type 
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.CampaignKey
			,p.CampaignID
			,p.CampaignName
			,ISNULL(p.CampaignID, '') + '-' + ISNULL(p.CampaignName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tCampaign p (NOLOCK) ON e.CampaignKey = p.CampaignKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 0
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		UNION ALL

		SELECT 'Change Orders' As Type 
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.ProjectKey
			,p.ProjectNumber
			,p.ProjectName
			,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		UNION ALL
	
		SELECT 'Change Orders' As Type 
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.LeadKey
			,''
			,p.Subject
			,ISNULL(p.Subject, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tLead p (NOLOCK) ON e.LeadKey = p.LeadKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
		
		UNION ALL
	
		SELECT 'Change Orders' As Type  
			,'tEstimate' As Entity
			,e.EstimateKey As EntityKey
			,e.EstimateDate as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,e.EstimateName As Reference
			,0 AS Selected
			
			,e.CampaignKey
			,p.CampaignID
			,p.CampaignName
			,ISNULL(p.CampaignID, '') + '-' + ISNULL(p.CampaignName, '') AS ProjectFullName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,e.EstimateDate
			,e.EstimateTotal + e.TaxableTotal as EstimateTotal
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail
			,isnull(u2.UserKey, 0) AS InternalApprover
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tCampaign p (NOLOCK) ON e.CampaignKey = p.CampaignKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = 1
		AND    ((e.InternalStatus = 2 AND e.InternalApprover = @UserKey) OR (e.InternalStatus = 4 AND e.ExternalStatus = 2 AND e.ExternalApprover = @UserKey))
		AND    p.CompanyKey = @CompanyKey
	End		

--- tBilling		
if (ISNULL(@Entity, 'tBilling') = 'tBilling')
	Begin		
		Select 'Billing Worksheets To Review' As Type
				,'tBilling' As Entity
				,b.BillingKey As EntityKey
				,b.DateCreated as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,b.BillingID As Reference
				,0 AS Selected
			,p.ProjectNumber
			,p.ProjectName 
			,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
			,c.CustomerID
			,c.CompanyName
			,u.FirstName + ' ' + u.LastName as AccountManager
			,b.DateCreated, b.DueDate
			,b.BillingMethod
			,Case b.BillingMethod
				When 1 then 'Time & Materials'
				When 2 then 'Fixed Fee'
				When 3 then 'Retainer'
				else 'Master Worksheet' end as MethodName
			,ISNULL(LaborTotal, 0) + ISNULL(ExpenseTotal, 0) + ISNULL(FFTotal, 0) + ISNULL(RetainerAmount, 0) AS ToBill	
			,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) 
				as BudgetAmount
			,(Select Sum(Amount) from tInvoiceSummary (nolock)
				inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceSummary.InvoiceKey
				Where tInvoiceSummary.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
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
	End

--- tBillingApprove
if (ISNULL(@Entity, 'tBillingApprove') = 'tBillingApprove')
	Begin			
		Select 'Billing Worksheets To Approve' As Type
				,'tBillingApprove' As Entity
				,b.BillingKey As EntityKey
				,b.DateCreated as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,b.BillingID As Reference
				,0 AS Selected
			,p.ProjectNumber
			,p.ProjectName 
			,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
			,c.CustomerID
			,c.CompanyName
			,u.FirstName + ' ' + u.LastName as AccountManager
			,b.DateCreated, b.DueDate
			,b.BillingMethod
			,Case b.BillingMethod
				When 1 then 'Time & Materials'
				When 2 then 'Fixed Fee'
				When 3 then 'Retainer'
				else 'Master Worksheet' end as MethodName
			,ISNULL(LaborTotal, 0) + ISNULL(ExpenseTotal, 0) + ISNULL(FFTotal, 0) + ISNULL(RetainerAmount, 0) AS ToBill	
			,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) 
				as BudgetAmount
			,(Select Sum(Amount) from tInvoiceSummary (nolock)
				inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceSummary.InvoiceKey
				Where tInvoiceSummary.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
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
	End	

--- myMeeting
if (ISNULL(@Entity, 'myMeeting') = 'myMeeting')
	Begin	
		SELECT distinct 
			'My Meetings' As Type
			,'myMeeting' As Entity
			,c.CalendarKey As EntityKey
			,c.EventStart as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,c.Subject As Reference
			,0 AS Selected
			,c.*, u.UserKey, u.FirstName + ' ' + u.LastName as Attendee
			,u.UserKey
			,u.TimeZoneIndex as AttendeeTimezoneIndex
			,(SELECT u2.TimeZoneIndex
			  FROM   tCalendarAttendee ca2 (nolock)
				INNER JOIN tUser u2 (nolock) ON ca2.EntityKey = u2.UserKey AND ca2.Entity = 'Organizer'  
				WHERE ca2.CalendarKey = c.CalendarKey
			 ) AS TimeZoneIndex 	-- needed to determine date of all day events for attendees 
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
	End

--- otherMeeting
if (ISNULL(@Entity, 'otherMeeting') = 'otherMeeting')
	Begin	
		SELECT distinct
			'Other People''s Meetings - ' As Type
			,'otherMeeting' As Entity
			,c.CalendarKey As EntityKey
			,c.EventStart as SortDate
			,1 as ShowCheckBox
			,NULL As ApprovalComments 
			,c.Subject As Reference
			,0 AS Selected
			, c.*, u.UserKey, u.FirstName + ' ' + u.LastName as Attendee
			,u.UserKey
			,u.TimeZoneIndex as AttendeeTimezoneIndex
			,(SELECT u2.TimeZoneIndex
			  FROM   tCalendarAttendee ca2 (nolock)
				INNER JOIN tUser u2 (nolock) ON ca2.EntityKey = u2.UserKey AND ca2.Entity = 'Organizer'  
				WHERE ca2.CalendarKey = c.CalendarKey
			 ) AS TimeZoneIndex 	-- needed to determine date of all day events for attendees 
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
	End
			
--- tVoucherCC
if (ISNULL(@Entity, 'tVoucherCC') = 'tVoucherCC')
	Begin	
		if @UserKey is null
			SELECT 'Credit Card Charges' AS Type
				,'tVoucherCC' As Entity
				,v.VoucherKey As EntityKey
				,v.InvoiceDate as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,v.InvoiceNumber As Reference
				,0 AS Selected
				,v.VendorID, v.VendorName
				,v.InvoiceDate
				,v.VoucherTotal
				,v.BoughtFrom
				,u.FirstName + ' ' + u.LastName AS Purchaser	    
				from vVoucher v (NOLOCK) 
					left join tUser u (NOLOCK) ON (v.BoughtByKey = u.UserKey)
			WHERE 
				v.Status = 4 AND 
				v.Posted = 0 AND
				v.CompanyKey = @CompanyKey AND
				isnull(v.CreditCard, 0) = 1 AND
				v.ApprovedByKey in (SELECT UserKey
									  FROM tUser u (NOLOCK)
										INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey
									 WHERE ra.EntityType = 'Security Group' AND RightKey = 60403)
			ORDER BY 
				v.VendorID, v.InvoiceNumber
		else
			SELECT 'Credit Card Charges' AS Type
				,'tVoucherCC' As Entity
				,v.VoucherKey As EntityKey
				,v.InvoiceDate as SortDate
				,1 as ShowCheckBox
				,NULL As ApprovalComments 
				,v.InvoiceNumber As Reference
				,0 AS Selected
				,v.VendorID, v.VendorName
				,v.InvoiceDate
				,v.VoucherTotal
				,v.BoughtFrom
				,u.FirstName + ' ' + u.LastName AS Purchaser	    
				from vVoucher v (NOLOCK) 
					left join tUser u (NOLOCK) ON (v.BoughtByKey = u.UserKey)
			WHERE v.Status = 2 
				AND v.CompanyKey = @CompanyKey
				AND isnull(v.CreditCard, 0) = 1
				AND (v.ApprovedByKey = @UserKey OR (v.ApprovedByKey IS NULL 
				AND @UserKey in (	SELECT UserKey
									FROM tUser u (NOLOCK)
									INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey
									WHERE ra.EntityType = 'Security Group' AND RightKey = 60403)))	
			ORDER BY 
				v.VendorID, v.InvoiceNumber
	End

--- tForecast
if (ISNULL(@Entity, 'tForecast') = 'tForecast')
	Begin	
		SELECT
			'Forecast' AS Type,
			'tForecast' AS Entity,
			f.ForecastKey AS EntityKey,
			f.ForecastName,
			DATENAME(m, CAST(f.StartMonth AS varchar(2)) + '/1/' + CAST(f.StartYear AS varchar(4))) + ' ' + CAST(f.StartYear AS varchar(4)) AS Starting,
			cb.UserFullName AS CreatedBy,
			fd.Total AS Total,
			fd.ItemCount AS ItemCount
		FROM
			tForecast f (nolock)
			INNER JOIN (
				SELECT SUM(Total) AS Total, COUNT(*) AS ItemCount, ForecastKey FROM tForecastDetail (nolock) WHERE AccountManagerKey = @UserKey GROUP BY ForecastKey
				) fd ON f.ForecastKey = fd.ForecastKey
			INNER JOIN vUserName cb ON f.CreatedBy = cb.UserKey
	End
GO
