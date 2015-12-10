USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTrafficUpdate]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTrafficUpdate]
	@PurchaseOrderTrafficKey int,
	@PurchaseOrderKey int,
	@ISCICode varchar(100),
	@ShowPercent decimal(24,4),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Comments varchar(2000)

AS --Encrypt

	UPDATE
		tPurchaseOrderTraffic
	SET
		PurchaseOrderKey = @PurchaseOrderKey,
		ISCICode = @ISCICode,
		ShowPercent = @ShowPercent,
		StartDate = @StartDate,
		EndDate = @EndDate,
		Comments = @Comments
	WHERE
		PurchaseOrderTrafficKey = @PurchaseOrderTrafficKey 

	RETURN 1
GO
