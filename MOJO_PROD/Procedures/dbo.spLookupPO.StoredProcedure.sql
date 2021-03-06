USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupPO]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLookupPO]
	(
		@CompanyKey INT,
		@VendorKey INT,
		@ID VARCHAR(50)
	)
AS --Encrypt
			
	IF @ID IS NULL
		SELECT	po.PurchaseOrderKey,
				po.PurchaseOrderNumber,
				po.PODate,
				ISNULL(Sum(pod.TotalCost), 0) as POTotal,
				ISNULL(Sum(pod.TotalCost), 0) - isnull(Sum(pod.AppliedCost), 0) AS POOpen
		FROM	tPurchaseOrder po (NOLOCK)
				inner join tPurchaseOrderDetail pod (NOLOCK) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		WHERE	po.CompanyKey = @CompanyKey
			AND   po.VendorKey  = @VendorKey
			AND   po.Status   = 4	-- Approved
			AND   po.Closed   = 0  -- Not Closed
		GROUP BY
				po.PurchaseOrderKey,
				po.PurchaseOrderNumber,
				po.PODate
		HAVING ISNULL(Sum(pod.TotalCost), 0) - isnull(Sum(pod.AppliedCost), 0) > 0
		ORDER BY po.PurchaseOrderNumber
	ELSE
		SELECT	po.PurchaseOrderKey,
				po.PurchaseOrderNumber,
				po.PODate,
				ISNULL(Sum(pod.TotalCost), 0) as POTotal,
				ISNULL(Sum(pod.TotalCost), 0) - isnull(Sum(pod.AppliedCost), 0) AS POOpen
		FROM	tPurchaseOrder po (NOLOCK)
				inner join tPurchaseOrderDetail pod (NOLOCK) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		WHERE	po.CompanyKey = @CompanyKey
			AND   po.VendorKey  = @VendorKey
			AND   po.Status   = 4	-- Approved
			AND   po.Closed   = 0  -- Not Closed
			AND	  po.PurchaseOrderNumber like @ID + '%'
		GROUP BY
				po.PurchaseOrderKey,
				po.PurchaseOrderNumber,
				po.PODate
		HAVING ISNULL(Sum(pod.TotalCost), 0) - isnull(Sum(pod.AppliedCost), 0) > 0
		ORDER BY po.PurchaseOrderNumber

	RETURN 1
GO
