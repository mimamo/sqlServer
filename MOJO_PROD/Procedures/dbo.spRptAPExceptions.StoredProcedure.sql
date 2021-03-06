USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAPExceptions]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptAPExceptions] 
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Days int,
	@UserKey int = null
AS -- Encrypt

/*
  || When     Who Rel     What
  || 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess 
  || 10/16/12 RLB 10.561  (156794) I talked with Mike W and he said this report should pull the pod.TotalCost instead of pod.AppliedCost
  || 07/16/13  WDF 10.5.7.0 (176497) Added VoucherID
  || 01/24/14 GHL 10.576  Added CurrencyID
*/

if @StartDate is null
	Select @StartDate = '1/1/1970'
	
if @EndDate is null
	Select @EndDate = '12/31/2050'

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

BEGIN
	SELECT 
	pay.PaymentKey,
	pay.PaymentDate as CheckDate,
	pay.CheckNumber as CheckNumber,
	(SELECT c.CompanyName FROM tCompany c (nolock) 
		WHERE c.CompanyKey = pay.VendorKey) as VendorName,
	pay.PaymentAmount as CheckAmount,
	pay.CurrencyID,
	proj.ProjectNumber as JobNumber,
	v.InvoiceNumber as InvoiceNumber,
	v.InvoiceDate as InvoiceDate,
	v.VoucherID,
	vd.TotalCost as InvoiceAmount,
	ISNULL((SELECT SUM(vd2.TotalCost) from tVoucherDetail vd2 (nolock)
			WHERE vd2.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as TotalInvoiced,
	po.PurchaseOrderNumber as PurchaseOrderNumber,
	po.PODate,
	CASE po.POKind
		WHEN 0 THEN po.PODate
		WHEN 1 THEN po.PODate
		WHEN 2 THEN po.FlightStartDate
	    ELSE po.PODate END AS PurchaseOrderDate,
	po.FlightStartDate,
	po.OrderedBy as IssuedBy,
	pod.TotalCost as POLineAmount,
	DATEDIFF(day,InvoiceDate,GETDATE()) as OverDueDays
	

FROM
	tPayment pay (nolock)
	left outer join	tPaymentDetail pd (nolock) on pd.PaymentKey = pay.PaymentKey
	left outer join tVoucher v (nolock) on v.VoucherKey = pd.VoucherKey
	left outer join tVoucherDetail vd (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tProject proj (nolock) on proj.ProjectKey = vd.ProjectKey
	left outer join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	left outer join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey

WHERE	
	pay.CompanyKey = @CompanyKey
	AND pay.PaymentDate >= @StartDate 
	AND pay.PaymentDate <= @EndDate
	--AND PODate > InvoiceDate
	--AND vd.TotalCost > pod.AppliedCost
	AND (@RestrictToGLCompany = 0 
		OR pay.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					
ORDER BY
	CheckNumber, VendorName, CheckDate, InvoiceNumber
END
GO
