USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDMiscExp]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDMiscExp]

	(
		@ProjectKey int
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/17/08  CRG 1.0.0.0 Added columns for new Project Budget View  
*/

	Select
		m.MiscCostKey,
		u.FirstName + ' ' + u.LastName as UserName,
		ta.TaskID,
		ta.TaskKey,
		m.ExpenseDate,
		m.ShortDescription,
		m.LongDescription,
		isnull(i.ItemName, '[No Item]') As ItemName,
		isnull(i.ItemKey, 0) As ItemKey,
		m.Quantity,
		m.UnitCost,
		m.TotalCost,
		m.UnitRate,
		m.BillableCost,
		m.InvoiceLineKey,
		m.ProjectKey,
		m.WriteOff,
		i.ItemID,
		ISNULL(ta.TaskID, '') + '-' + ISNULL(ta.TaskName, '') AS TaskIDName,
		d.DepartmentName,
		c.ClassName,
		m.Billable,
		m.AmountBilled,
		inv.InvoiceNumber,
		inv.InvoiceDate,
		inv.PostingDate,
		CASE m.WriteOff
			WHEN 1 THEN m.DateBilled
			ELSE NULL
		END AS WriteOffDate,
		wor.ReasonName AS WriteOffReason,
		CASE m.WIPPostingInKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedIntoWIP,
		CASE m.WIPPostingOutKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedOutOfWIP,
		m.TransferComment,
		CASE 
			WHEN m.InvoiceLineKey IS NULL THEN
				CASE m.WriteOff
					WHEN 1 THEN 'Written Off'
					ELSE 'Unbilled'
				END
			ELSE 'Billed'
		END AS BillingStatus
	From
		tMiscCost m (nolock)
		Inner Join tTask ta (nolock) on ta.TaskKey = m.TaskKey
		Inner Join tUser u (nolock) on u.UserKey = m.EnteredByKey
		left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
		LEFT JOIN tDepartment d (nolock) ON m.DepartmentKey = d.DepartmentKey
		LEFT JOIN tClass c (nolock) ON m.ClassKey = c.ClassKey
		LEFT JOIN tInvoiceLine il (nolock) ON m.InvoiceLineKey = il.InvoiceLineKey
		LEFT JOIN tInvoice inv (nolock) ON il.InvoiceKey = inv.InvoiceKey
		LEFT JOIN tWriteOffReason wor (nolock) on m.WriteOffReasonKey = wor.WriteOffReasonKey
	Where
		m.ProjectKey = @ProjectKey
	Order By ExpenseDate
GO
