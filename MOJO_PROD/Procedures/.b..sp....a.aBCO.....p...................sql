USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCOrderSpot]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCOrderSpot]
	(
		@PurchaseOrderKey int,
		@LinkID varchar(50),
		@ISCICode varchar(100),
		@ShowPercent decimal(24,4),
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@Comments varchar(2000)
	)

AS --Encrypt


Declare @TrafficKey int, @NewKey int

Select @TrafficKey = MIN(PurchaseOrderTrafficKey) from tPurchaseOrderTraffic (nolock)
	Where PurchaseOrderKey = @PurchaseOrderKey and LinkID = @LinkID
	
if @TrafficKey is null
BEGIN
	Exec sptPurchaseOrderTrafficInsert
		@PurchaseOrderKey,
		@ISCICode,
		@ShowPercent,
		@StartDate,
		@EndDate,
		@Comments,
		@NewKey output

	Update tPurchaseOrderTraffic Set LinkID = @LinkID Where PurchaseOrderTrafficKey = @NewKey
END
ELSE
BEGIN

	Update tPurchaseOrderTraffic
	Set
		ISCICode = @ISCICode,
		ShowPercent = @ShowPercent,
		StartDate = @StartDate,
		EndDate = @EndDate,
		Comments = @Comments
	Where PurchaseOrderTrafficKey = @TrafficKey

END
GO
