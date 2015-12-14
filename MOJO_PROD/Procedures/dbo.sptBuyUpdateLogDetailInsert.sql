USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogDetailInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptBuyUpdateLogDetailInsert]
	@BuyUpdateLogKey bigint,
	@PurchaseOrderKey int,
	@Action char(1),
	@PurchaseOrderDetailKey int,
	@LineType varchar(50),
	@DetailOrderDate smalldatetime,
	@MediaPremiumKey int,
	@PremiumAmountType varchar(50),
	@PremiumPct decimal(24, 4),
	@Quantity decimal(24, 4),
	@Quantity1 decimal(24, 4),
	@Quantity2 decimal(24, 4),
	@UnitRate money,
	@UnitCost money,
	@GrossAmount money,
	@Commission decimal(24, 4),
	@TotalCost money,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@TotalPremiumsNet money,
	@TotalPremiumsGross money,
	@TotalPremiumsTax1 money,
	@TotalPremiumsTax2 money,
	@TotalGross money,
	@TotalClient money,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@DetailData varchar(max),
	@BuyUpdateLogDetailKey uniqueidentifier output
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created
*/

	SELECT	@BuyUpdateLogDetailKey = NEWID()

	INSERT tBuyUpdateLogDetail
           (BuyUpdateLogDetailKey,
           BuyUpdateLogKey,
           PurchaseOrderKey,
           Action,
           PurchaseOrderDetailKey,
           LineType,
           DetailOrderDate,
           MediaPremiumKey,
           PremiumAmountType,
           PremiumPct,
           Quantity,
           Quantity1,
           Quantity2,
           UnitRate,
           UnitCost,
           GrossAmount,
           Commission,
           TotalCost,
           SalesTax1Amount,
           SalesTax2Amount,
           TotalPremiumsNet,
           TotalPremiumsGross,
           TotalPremiumsTax1,
           TotalPremiumsTax2,
           TotalGross,
           TotalClient,
           SalesTaxKey,
           SalesTax2Key,
           DetailData)
     VALUES
           (@BuyUpdateLogDetailKey,
           @BuyUpdateLogKey,
           @PurchaseOrderKey,
           @Action,
           @PurchaseOrderDetailKey,
           @LineType,
           @DetailOrderDate,
           @MediaPremiumKey,
           @PremiumAmountType,
           @PremiumPct,
           @Quantity,
           @Quantity1,
           @Quantity2,
           @UnitRate,
           @UnitCost,
           @GrossAmount,
           @Commission,
           @TotalCost,
           @SalesTax1Amount,
           @SalesTax2Amount,
           @TotalPremiumsNet,
           @TotalPremiumsGross,
           @TotalPremiumsTax1,
           @TotalPremiumsTax2,
           @TotalGross,
           @TotalClient,
           @SalesTaxKey,
           @SalesTax2Key,
           @DetailData)
GO
