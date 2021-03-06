USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetApprovalList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderGetApprovalList]

	(
		@UserKey int,
		@Type smallint
	)

AS --Encrypt

Declare @ApprovalLimit as money, @CompanyKey int

if @Type = 0
	Select @ApprovalLimit = ISNULL(POLimit, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (NOLOCK) Where UserKey = @UserKey
else if @Type = 1
	Select @ApprovalLimit = ISNULL(IOLimit, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (NOLOCK) Where UserKey = @UserKey
else if @Type = 2
	Select @ApprovalLimit = ISNULL(BCLimit, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (NOLOCK) Where UserKey = @UserKey
	
if exists(Select 1 from tUser Where UserKey = @UserKey and ClientVendorLogin = 1)
	Select @ApprovalLimit = -999
	
	
SELECT 
	po.PurchaseOrderKey, 
	po.PurchaseOrderNumber, 
	c.CompanyName AS VendorName, 
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
	po.POKind = @Type and
	po.CompanyKey = @CompanyKey
GROUP BY 
	po.PurchaseOrderKey, 
	po.PurchaseOrderNumber, 
	c.CompanyName, 
	po.PODate, 
	po.OrderedBy,
	po.CreatedByKey,
	po.ApprovedByKey,
	tUser.Email
Having ISNULL(SUM(pod.TotalCost), 0) <= @ApprovalLimit and 
(ISNULL(ApprovedByKey, 0) = 0 or ISNULL(ApprovedByKey, 0) = @UserKey)

ORDER BY 
	po.PurchaseOrderNumber

Return
GO
