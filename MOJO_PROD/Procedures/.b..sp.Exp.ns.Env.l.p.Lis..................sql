USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeList]
 @CompanyKey int,
 @UserKey int
 
AS --Encrypt

/*
|| When      Who Rel		What
|| 05/13/14  MAS 10.5.7.9   Created
|| 07/13/14  MAS 10.5.7.9   Added User and CompanyKey
*/


SELECT 
	ee.CompanyKey,
	ee.UserKey, 
	ee.ExpenseEnvelopeKey,
    u.FirstName AS [FirstName], 
    u.LastName AS [LastName], 
    u.FirstName + ' ' + u.LastName AS [FullName],
    u.SystemID AS [System ID], 
    u2.FirstName + ' ' + u2.LastName AS [ApproverName], 
    LTRIM(RTRIM(ee.EnvelopeNumber)) AS [EnvelopeNumber],
    ee.StartDate AS [StartDate], 
    ee.EndDate AS [EndDate], 
    ee.DateCreated AS [DateCreated], 
    ee.DateSubmitted AS [DateSubmitted], 
    ee.DateApproved AS [DateApproved], 
    ee.ApprovalComments AS [ApprovalComments],
    ISNULL(ee.Comments, '') as [Comments],
	vend.VendorID as [VendorID],
	vend.CompanyName as [VendorName],
	vend.VendorID + ' - ' + vend.CompanyName as [VendorFullName],
	case ee.Status
		When 1 then 'Unsubmitted'
		When 2 then 'Submitted'
		When 3 then 'Rejected'
		When 4 then 'Approved' end as [ApprovalStatus],
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
	v.InvoiceNumber as [InvoiceNumberPaidOn],
	convert(nvarchar(50), v.VoucherID) as [UniqueAutoNumber],
	isnull((select sum(ActualCost) 
	from tExpenseReceipt cst (nolock)
	where ee.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as [ExpenseTotal],
	u.GLCompanyKey,
	(Select COUNT(*) From tExpenseReceipt(nolock) Where ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey) As [ReceiptCount],
	(Select MIN(ExpenseDate) From tExpenseReceipt(nolock) Where ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey) As [FromDate],
	(Select MAX(ExpenseDate) From tExpenseReceipt(nolock) Where ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey) As [ToDate]

From 
	tExpenseEnvelope ee (nolock) 
	Inner join tUser u (nolock) on ee.UserKey = u.UserKey
	left outer join tCompany vend (nolock) on ee.VendorKey = vend.CompanyKey
	Left outer join tUser u2 (nolock) on u.ExpenseApprover = u2.UserKey
	left outer join tVoucher v (nolock) on ee.VoucherKey = v.VoucherKey
Where ee.CompanyKey = @CompanyKey AND ee.UserKey = @UserKey
AND ee.Status in (1,2,3) -- Unsubmitted(1), Submitted(2), Rejected(3), Approved(4)
GO
