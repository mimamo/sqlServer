USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_ExpenseReport]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_ExpenseReport]
AS

/*
|| When      Who Rel      What
|| 04/13/10  RLB 10521    (66713) Changed Paid to look at voucher AmountPaid if there was a voucher created
|| 03/12/12  RLB 10554    (130722) Added Comment field from the expense report
|| 04/02/12  MFT 10.5.5.5  Added GLCompanyKey in order to map/restrict
|| 07/17/13  WDF 10.5.7.0 (176497) Added VoucherID
*/


SELECT 
	ee.CompanyKey,
	ee.UserKey, 
	ee.ExpenseEnvelopeKey,
    u.FirstName AS [First Name], 
    u.LastName AS [Last Name], 
    u.FirstName + ' ' + u.LastName AS [Full Name],
    u.SystemID AS [System ID], 
    u2.FirstName + ' ' + u2.LastName AS [Approver Name], 
    ee.EnvelopeNumber AS [Envelope Number],
    ee.StartDate AS [Start Date], 
    ee.EndDate AS [End Date], 
    ee.DateCreated AS [Date Created], 
    ee.DateSubmitted AS [Date Submitted], 
    ee.DateApproved AS [Date Approved], 
    ee.ApprovalComments AS [Approval Comments],
    ee.Comments as [Comments],
	vend.VendorID as [Vendor ID],
	vend.CompanyName as [Vendor Name],
	vend.VendorID + ' - ' + vend.CompanyName as [Vendor Full Name],
	case ee.Status
		When 1 then 'Unsubmitted'
		When 2 then 'Submitted'
		When 3 then 'Rejected'
		When 4 then 'Approved' end as [Approval Status],
	case ee.VoucherKey when 0 then
		case
			When ee.Paid = 1 then 'YES'
		Else 'NO'
		End
	Else 
		case 
			When v.VoucherTotal = v.AmountPaid then 'YES'
		Else 'NO'
		End
	End AS [Paid], 
	v.InvoiceNumber as [Invoice Number Paid On],
	convert(nvarchar(50), v.VoucherID) as [Unique Auto Number],
	isnull((select sum(ActualCost) 
	from tExpenseReceipt cst (nolock)
	where ee.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as [Expense Total],
	u.GLCompanyKey
From 
	tExpenseEnvelope ee (nolock) 
	Inner join tUser u (nolock) on ee.UserKey = u.UserKey
	left outer join tCompany vend (nolock) on ee.VendorKey = vend.CompanyKey
	Left outer join tUser u2 (nolock) on u.ExpenseApprover = u2.UserKey
	left outer join tVoucher v (nolock) on ee.VoucherKey = v.VoucherKey
GO
