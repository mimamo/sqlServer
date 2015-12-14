USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherPost]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherPost]

	(
		@VoucherKey int,
		@PostDate smalldatetime
	)

AS --Encrypt

	IF (SELECT Posted
	    FROM   tVoucher (NOLOCK)
	    WHERE  VoucherKey = @VoucherKey) = 1
	   RETURN -1
	     
	UPDATE
		tVoucher
	SET
		Posted = 1
	WHERE
		VoucherKey = @VoucherKey
		
	DECLARE @PurchaseOrderDetailKey INT
					,@PurchaseOrderKey INT
				  ,@POCost money
				  ,@VoucherCost money
				  
	SELECT @PurchaseOrderDetailKey = -1	
	WHILE	(1=1)
	BEGIN
		SELECT @PurchaseOrderDetailKey = MIN(PurchaseOrderDetailKey)
		FROM   tVoucherDetail  (NOLOCK)
		WHERE  VoucherKey = @VoucherKey
		AND    PurchaseOrderDetailKey > @PurchaseOrderDetailKey
		AND    PurchaseOrderDetailKey IS NOT NULL
		
		IF @PurchaseOrderDetailKey IS NULL
			BREAK
			
		SELECT @PurchaseOrderKey = PurchaseOrderKey
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		
		SELECT @POCost = 0
		      ,@VoucherCost = 0
		      
		SELECT @POCost = SUM(TotalCost)
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  PurchaseOrderKey = @PurchaseOrderKey  	
		
		SELECT @VoucherCost = SUM(vd.TotalCost)
		FROM   tPurchaseOrderDetail pod (NOLOCK)
		      ,tVoucher             v   (NOLOCK)
		      ,tVoucherDetail       vd  (NOLOCK)
		WHERE  pod.PurchaseOrderKey = @PurchaseOrderKey  	
		AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		AND    vd.VoucherKey        = v.VoucherKey
		AND    v.Posted             = 1
		 
	
		IF @POCost = @VoucherCost
			exec sptPurchaseOrderClose @PurchaseOrderKey
	END
	
	RETURN 1
GO
