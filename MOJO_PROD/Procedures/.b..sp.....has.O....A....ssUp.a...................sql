USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderAddressUpdate]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderAddressUpdate]
	@PurchaseOrderKey int,
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@DeliveryInstructions varchar(1000),
	@SpecialInstructions varchar(MAX),
	@DeliverTo1 varchar(100),
	@DeliverTo2 varchar(100),
	@DeliverTo3 varchar(100),
	@DeliverTo4 varchar(100),
	@LastUpdateBy int = NULL

AS --Encrypt

/*
|| 04/13/07 BSH 8.4.5 DateUpdated needed to be updated. 
|| 12/13/12 WDF 8.4.5 10.563  (162210) Added LastUpdateBy 
|| 08/15/13 CRG 10.5.7.1 (151865) Changed @SpecialInstructions to varchar(MAX) 
|| 04/28/14 RLB 10.5.7.9 (209351) Allow this to update after it has been prebilled or on a voucher
|| 05/09/14 RLB 10.5.7.9 (209351) Allow updates when PO is closed because fields should be locked down that can not be updated
*/

/*	IF EXISTS (SELECT 1
	           FROM   tVoucherDetail vd (NOLOCK)
	                 ,tPurchaseOrderDetail pod (NOLOCK)
	                 ,tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    po.PurchaseOrderKey = pod.PurchaseOrderKey
						 AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
		RETURN -1

		
	IF EXISTS (SELECT 1
	           FROM		tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    (po.Closed = 1))
		RETURN -2		
*/					
	UPDATE
		tPurchaseOrder
	SET
		Address1 = @Address1,
		Address2 = @Address2,
		Address3 = @Address3,
		City = @City,
		State = @State,
		PostalCode = @PostalCode,
		Country = @Country,
		DeliveryInstructions = @DeliveryInstructions,
		SpecialInstructions = @SpecialInstructions,
		DeliverTo1 = @DeliverTo1,
		DeliverTo2 = @DeliverTo2,
		DeliverTo3 = @DeliverTo3,
		DeliverTo4 = @DeliverTo4,
        DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
		LastUpdateBy = @LastUpdateBy
	WHERE
		PurchaseOrderKey = @PurchaseOrderKey 

	RETURN 1
GO
