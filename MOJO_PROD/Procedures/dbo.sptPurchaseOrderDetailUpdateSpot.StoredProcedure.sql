USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdateSpot]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailUpdateSpot]


	@PurchaseOrderDetailKey int,
	@Quantity decimal(24,4),
	@DetailOrderDate smalldatetime,
	@DetailOrderEndDate smalldatetime,
	@UserDate1 smalldatetime,
	@UserDate2 smalldatetime,
	@UserDate3 smalldatetime,
	@UserDate4 smalldatetime,
	@UserDate5 smalldatetime,
	@UserDate6 smalldatetime


AS --Encrypt

/*
|| When     Who Rel      What
|| 05/23/07 GHL 8.422    Fixed rounding problem with the calc of TotalCost. Bug 9306
|| 04/01/09 RTC 10.0.2.2 (49681) TotalCost was not always stored as two decimal places.  When the Flight Type was Summary, TotalCost
||                       could have more than two decimal places.  Now it will always be rounded to two decimals.
|| 07/07/11 GHL 10.546   (111482) calling now sptPurchaseOrderRollupAmounts instead of recalculating the taxes
|| 02/03/14 GHL 10.576   Added update of PTotalCost
*/

declare @PurchaseOrderKey int
declare @ProjectKey int
declare @FlightInterval tinyint


	select @PurchaseOrderKey = PurchaseOrderKey
	      ,@ProjectKey = ProjectKey
	  from tPurchaseOrderDetail (nolock)
	 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	select @FlightInterval = isnull(FlightInterval,3)
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	 
	IF EXISTS (SELECT 1 FROM  tVoucherDetail vd (NOLOCK)
				inner join tPurchaseOrderDetail pod (NOLOCK) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				WHERE  pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey)
		RETURN -1	
	
	IF EXISTS (SELECT 1
	           FROM		tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    (po.Closed = 1))
		RETURN -2
		
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -3
			
		if @FlightInterval = 3
			UPDATE
				tPurchaseOrderDetail
			SET
				Quantity = @Quantity,
				UserDate1 = @UserDate1,
				UserDate2 = @UserDate2,
				UserDate3 = @UserDate3,
				UserDate4 = @UserDate4,
				UserDate5 = @UserDate5,
				UserDate6 = @UserDate6,
				BillableCost = round(@Quantity*UnitCost,2),
				TotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2),
				PTotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2)
			WHERE
				PurchaseOrderDetailKey = @PurchaseOrderDetailKey 		
		else
			UPDATE
				tPurchaseOrderDetail
			SET
				Quantity = @Quantity,
				DetailOrderDate = @DetailOrderDate,
				DetailOrderEndDate = @DetailOrderEndDate,
				UserDate1 = @UserDate1,
				UserDate2 = @UserDate2,
				UserDate3 = @UserDate3,
				UserDate4 = @UserDate4,
				UserDate5 = @UserDate5,
				UserDate6 = @UserDate6,
				BillableCost = round(@Quantity*UnitCost,2),
				TotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2),
				PTotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2)
			WHERE
				PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	
		
	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey, 0  

	RETURN 1
GO
