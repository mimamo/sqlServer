USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryGetList]
	@CompanyKey int,
	@UserKey int,
	@GLAccountKey int,
	@HideClearedTransactions tinyint,
	@HideCreditTransactions tinyint,
	@StartDate smalldatetime,
	@EndDate smalldatetime

AS --Encrypt

/*
|| When      Who Rel		What
|| 02/08/12  MAS 10.5.5.2	Created
|| 03/29/12  MAS 10.5.5.4	Added office and GLCompany
|| 04/13/12  MAS 10.5.5.4	Exclude CCEntries that have been processed
|| 04/22/12  MAS 10.5.5.5	Only return records for credit cards the user as access
|| 6/27/12   CRG 10.5.5.7   Added Department and Expense Account
|| 6/28/12   CRG 10.5.5.7   Added Overhead
|| 6/29/12   CRG 10.5.5.7   Moved filtering criteria to this SP and out of Flex
|| 7/2/12    CRG 10.5.5.7   Removed the GLAccount rights logic because now a single GLAccountKey is passed in.
|| 7/6/12    GWG 10.5.5.7   Added Class and 2 sales tax
|| 8/28/12   GHL 10.5.5.9   Added Attachment count + Processed Status + GLCompanyKey + real vendor name + fixed date range
|| 09/04/12  GHL 10.5.6.0   Added Credit Card Entry splits (tCCEntrySplit records) 
|| 09/04/12  GHL 10.5.6.0   Removed 2 display fields for project and voucher splits since they are now displayed
||                          on same columns than ProjectNumber and InvoiceNumber + fixed sales tax 2 + added VoucherKey
|| 09/18/12  GHL 10.5.6.0   (154717) Added Billable field and taking now tCCEntry.* rather than list of tCCEntry fields 
|| 10/29/12  RLB 10.5.6.1   Added some HMI restrictions on the vouchers pulling into the unmatch list
|| 12/19/12  RLB 10.5.6.2   (162945) Pull only vouchers for that credit card and order by Invoice Date
|| 08/28/13  WDF 10.5.7.1   (179763) Added PostingDate
|| 12/15/13  GWG 10.5.7.5   Added a label for possible duplicate
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0) 
from tUser u (nolock) 
inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where u.UserKey = @UserKey


if @StartDate is null
	select @StartDate = '01/01/1900'
if @EndDate is null
	select @EndDate = '01/01/2079'

SELECT 
	cc.*,
	ta.TaskID, 
	ta.TaskID + ' ' + ta.TaskName as TaskFullName,
	ta.TaskName,
	p.ProjectNumber, 
	p.ProjectName,
	p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
	i.ItemName, i.ItemID,
	o.OfficeID, o.OfficeName,
	glc.GLCompanyID,
	glc.GLCompanyName,
	LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName,''))) As UserName,
	c.VendorID, c.CompanyName AS VendorName,
	v.InvoiceNumber,
	v.PostingDate,
	d.DepartmentName,
	ea.AccountNumber as ExpenseAccountNumber, ea.AccountName as ExpenseAccountName,
	cl.ClassID,
	cl.ClassName,
	st.SalesTaxID,
	st.SalesTaxName,
	st2.SalesTaxID as SalesTax2ID,
	st2.SalesTaxName as SalesTax2Name,

	(select count(*) from tAttachment att (nolock) where att.AssociatedEntity = 'tCCEntry' and att.EntityKey = cc.CCEntryKey) 
	as AttachmentCount,
	
	case isnull(cc.CCVoucherKey, 0)
		when -1 then 'Marked as Processed'
		when -2 then 'Possible Duplicate'
		when 0 then 'Unprocessed'
		else 'Processed'
	end as ProcessedStatus
	
	,(select count(*) from tCCEntrySplit (nolock) where tCCEntrySplit.CCEntryKey = cc.CCEntryKey and tCCEntrySplit.ProjectKey > 0)
	as ProjectCount

	,(select count(*) from tCCEntrySplit (nolock) where tCCEntrySplit.CCEntryKey = cc.CCEntryKey and tCCEntrySplit.VoucherKey > 0)
	as VoucherCount

FROM tCCEntry cc (nolock)	
	LEFT OUTER JOIN tTask ta (nolock) on cc.TaskKey = ta.TaskKey
	LEFT OUTER JOIN tProject p (nolock) on cc.ProjectKey = p.ProjectKey	
	LEFT OUTER JOIN tItem i (nolock) on cc.ItemKey = i.ItemKey
	LEFT OUTER JOIN tOffice o (NOLOCK) ON cc.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tGLAccount gl (nolock) on cc.GLAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON cc.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tVoucher v (nolock) on cc.VoucherKey = v.VoucherKey
	LEFT OUTER JOIN tUser u (nolock) on cc.ChargedByKey = u.UserKey
	LEFT OUTER JOIN tCompany c (NOLOCK) ON cc.VendorKey = c.CompanyKey
	LEFT OUTER JOIN tDepartment d (nolock) ON cc.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tGLAccount ea (nolock) ON cc.ExpenseAccountKey = ea.GLAccountKey
	LEFT OUTER JOIN tClass cl (nolock) on cc.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tSalesTax st (nolock) on cc.SalesTaxKey = st.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on cc.SalesTax2Key = st2.SalesTaxKey
-- Change where clause below for CCEntry splits if this one is changed
WHERE cc.CompanyKey = @CompanyKey
AND	cc.GLAccountKey = @GLAccountKey
AND ISNULL(cc.CCVoucherKey,0) <= 0 --If the CCVoucherKey > 0, then it's already linked to a voucher and we are not going to pull it
AND (ISNULL(@HideClearedTransactions, 0) = 0 OR ISNULL(cc.CCVoucherKey, 0) = 0) --If HideClearedTransactions = 1, then the CCVoucherKey must = 0
AND (ISNULL(@HideCreditTransactions, 0) = 0 OR ISNULL(cc.Amount, 0) >= 0)
AND  cc.TransactionPostedDate >= @StartDate
AND  cc.TransactionPostedDate <= @EndDate

 		
SELECT v.*,
	p.ProjectNumber, 
	p.ProjectName,
	p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
	c.VendorID + ' - ' + c.CompanyName AS VendorFullName,
	case 
		when isnull(c2.CompanyKey, 0) = 0 then v.BoughtFrom
		else c2.VendorID + ' - ' + c2.CompanyName
	end as RealVendorFullName
FROM tVoucher v (nolock)
	LEFT OUTER JOIN tProject p (nolock) on v.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany c (nolock) on v.VendorKey = c.CompanyKey
	LEFT OUTER JOIN tCompany c2 (nolock) on v.BoughtFromKey = c2.CompanyKey
WHERE v.CCEntryKey IS NULL 
AND v.CompanyKey = @CompanyKey
AND v.APAccountKey = @GLAccountKey
AND ISNULL(v.CreditCard, 0) = 1
AND (@RestrictToGLCompany = 0 OR (v.GLCompanyKey in (Select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)))
Order By v.InvoiceDate

-- Splits by Project
SELECT  ccs.*
       ,p.ProjectNumber
	   ,p.ProjectName
	   ,t.TaskID
	   ,t.TaskName
FROM  tCCEntry cc (nolock)
INNER JOIN tCCEntrySplit ccs (nolock) on cc.CCEntryKey = ccs.CCEntryKey
INNER JOIN tProject p (nolock) on ccs.ProjectKey = p.ProjectKey 
LEFT OUTER JOIN tTask t (nolock) on ccs.TaskKey = t.TaskKey  
-- same where clause as above
WHERE cc.CompanyKey = @CompanyKey
AND	cc.GLAccountKey = @GLAccountKey
AND ISNULL(cc.CCVoucherKey,0) <= 0 --If the CCVoucherKey > 0, then it's already linked to a voucher and we are not going to pull it
AND (ISNULL(@HideClearedTransactions, 0) = 0 OR ISNULL(cc.CCVoucherKey, 0) = 0) --If HideClearedTransactions = 1, then the CCVoucherKey must = 0
AND (ISNULL(@HideCreditTransactions, 0) = 0 OR ISNULL(cc.Amount, 0) >= 0)
AND  cc.TransactionPostedDate >= @StartDate
AND  cc.TransactionPostedDate <= @EndDate

-- Splits by Vendor Invoice
SELECT  ccs.*
       ,v.InvoiceNumber
	   ,ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) As OpenAmount
FROM  tCCEntry cc (nolock)
INNER JOIN tCCEntrySplit ccs (nolock) on cc.CCEntryKey = ccs.CCEntryKey
INNER JOIN tVoucher v (nolock) on ccs.VoucherKey = v.VoucherKey 
-- same where clause as above
WHERE cc.CompanyKey = @CompanyKey
AND	cc.GLAccountKey = @GLAccountKey
AND ISNULL(cc.CCVoucherKey,0) <= 0 --If the CCVoucherKey > 0, then it's already linked to a voucher and we are not going to pull it
AND (ISNULL(@HideClearedTransactions, 0) = 0 OR ISNULL(cc.CCVoucherKey, 0) = 0) --If HideClearedTransactions = 1, then the CCVoucherKey must = 0
AND (ISNULL(@HideCreditTransactions, 0) = 0 OR ISNULL(cc.Amount, 0) >= 0)
AND  cc.TransactionPostedDate >= @StartDate
AND  cc.TransactionPostedDate <= @EndDate
GO
