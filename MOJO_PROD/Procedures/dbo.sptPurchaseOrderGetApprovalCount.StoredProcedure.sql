USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetApprovalCount]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderGetApprovalCount]

	(
		@UserKey int
	)

AS --Encrypt

Declare @ApprovalLimit as money, @CompanyKey int, @POCount int

Select @ApprovalLimit = ISNULL(POLimit, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (NOLOCK) Where UserKey = @UserKey

	
SELECT 
	@POCount = Count(*)
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
	po.PurchaseOrderKey, ApprovedByKey
Having ISNULL(SUM(pod.TotalCost), 0) <= @ApprovalLimit and 
(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

    
Return @POCount
GO
