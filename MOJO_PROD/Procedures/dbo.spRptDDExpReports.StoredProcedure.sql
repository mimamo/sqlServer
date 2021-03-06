USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDExpReports]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDExpReports]

	(
		@ProjectKey int
	)

AS --Encrypt

  /*
  || When     Who Rel     What
  || 07/09/07 GHL 8.5     Added restriction on ERs           
  || 07/10/07 QMD 8.5     Expense Type reference changed to tItem 
  || 03/17/08 CRG 1.0.0.0 Added columns for new Project Budget View        
  */

	Select
		er.ExpenseEnvelopeKey,
		u.FirstName + ' ' + u.LastName as UserName,
		ta.TaskID,
		ta.TaskKey,
		isnull(i.ItemName, '[No Item]') as ItemName,
		isnull(i.ItemKey, 0) as ItemKey,
		er.ProjectKey,
		er.ExpenseDate,
		er.ActualQty,
		er.ActualUnitCost,
		er.ActualCost,
		er.BillableCost,
		er.Description,
		er.Comments,
		er.InvoiceLineKey,
		ee.EnvelopeNumber,
		er.UnitRate,
		er.Billable,
		er.AmountBilled,
		inv.InvoiceNumber,
		inv.InvoiceDate,
		inv.PostingDate,
		er.WriteOff,
		CASE er.WriteOff
			WHEN 1 THEN er.DateBilled
			ELSE NULL
		END AS WriteOffDate,
		wor.ReasonName AS WriteOffReason,
		CASE er.WIPPostingInKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedIntoWIP,
		CASE er.WIPPostingOutKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedOutOfWIP,
		er.TransferComment,
		ee.Paid,
		ISNULL(ta.TaskID, '') + '-' + ISNULL(ta.TaskName, '') AS TaskIDName,
		CASE ee.Status
			WHEN 4 THEN 1
			ELSE 0
		END AS ApprovalStatus, --Used for grid filtering		
		CASE 
			WHEN er.InvoiceLineKey IS NULL THEN
				CASE er.WriteOff
					WHEN 1 THEN 'Written Off'
					ELSE 'Unbilled'
				END
			ELSE 'Billed'
		END AS BillingStatus
	From	tExpenseReceipt er (nolock)
			Left Outer Join tTask ta (nolock) on ta.TaskKey = er.TaskKey
			Inner Join tUser u (nolock) on u.UserKey = er.UserKey
			Left Outer Join tItem i (nolock) on i.ItemKey = er.ItemKey
			inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
			LEFT JOIN tInvoiceLine il (nolock) ON er.InvoiceLineKey = il.InvoiceLineKey
			LEFT JOIN tInvoice inv (nolock) ON il.InvoiceKey = inv.InvoiceKey
			LEFT JOIN tWriteOffReason wor (nolock) on er.WriteOffReasonKey = wor.WriteOffReasonKey
	Where	er.ProjectKey = @ProjectKey
	And		er.VoucherDetailKey is null
	Order By ee.EnvelopeNumber
GO
