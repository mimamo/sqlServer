USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTrafficInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTrafficInsert]
	@PurchaseOrderKey int,
	@ISCICode varchar(100),
	@ShowPercent decimal(24,4),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Comments varchar(2000),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tPurchaseOrderTraffic
		(
		PurchaseOrderKey,
		ISCICode,
		ShowPercent,
		StartDate,
		EndDate,
		Comments
		)

	VALUES
		(
		@PurchaseOrderKey,
		@ISCICode,
		@ShowPercent,
		@StartDate,
		@EndDate,
		@Comments
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
