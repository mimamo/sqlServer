USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptBuyUpdateLogInsert]
	@CompanyKey int,
	@UserKey int,
	@MediaWorksheetKey int,
	@PurchaseOrderKey int,
	@Action char(1),
	@POKind smallint,
	@InternalID int,
	@Status smallint,
	@Revision int,
	@Printed tinyint,
	@Emailed tinyint,
	@PurchaseOrderNumber varchar(30),
	@BillingBase smallint,
	@BillingAdjPercent decimal(24, 4),
	@BillingAdjBase smallint,
	@CompanyMediaKey int,
	@VendorKey int,
	@ItemKey int,
	@MediaUnitTypeKey int,
	@HeaderData varchar(max),
	@BuyUpdateLogKey bigint OUTPUT --Because you can't return a bigint with the RETURN statement
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created
*/

	INSERT	tBuyUpdateLog
			(CompanyKey,
			UserKey,
			MediaWorksheetKey,
			PurchaseOrderKey,
			Action,
			POKind,
			InternalID,
			Status,
			Revision,
			Printed,
			Emailed,
			PurchaseOrderNumber,
			BillingBase,
			BillingAdjPercent,
			BillingAdjBase,
			CompanyMediaKey,
			VendorKey,
			ItemKey,
			MediaUnitTypeKey,
			HeaderData)
	VALUES	(@CompanyKey,
			@UserKey,
			@MediaWorksheetKey,
			@PurchaseOrderKey,
			@Action,
			@POKind,
			@InternalID,
			@Status,
			@Revision,
			@Printed,
			@Emailed,
			@PurchaseOrderNumber,
			@BillingBase,
			@BillingAdjPercent,
			@BillingAdjBase,
			@CompanyMediaKey,
			@VendorKey,
			@ItemKey,
			@MediaUnitTypeKey,
			@HeaderData)
			
	SELECT	@BuyUpdateLogKey = @@IDENTITY
GO
