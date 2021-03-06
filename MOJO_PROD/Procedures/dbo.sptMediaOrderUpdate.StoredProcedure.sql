USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaOrderUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaOrderUpdate]
	@MediaOrderKey int = NULL,
	@MediaWorksheetKey int,
	@PurchaseOrderKey int = NULL,
	@Revision int = NULL
AS

/*
  || When     Who Rel      What
  || 05/07/14 MFT 10.5.7.9 Created
  || 05/14/14 MFT 10.5.7.9 Trimed OrderNumber
*/

DECLARE
	@CompanyKey int,
	@TranType varchar(50),
	@OrderNumber varchar(30),
	@CurrentRevision int,
	@Status int

SELECT
	@CompanyKey = CompanyKey,
	@TranType = CASE POKind WHEN 1 THEN 'IO' WHEN 2 THEN 'BC' WHEN 4 THEN 'INT' ELSE 'IO' END
FROM tMediaWorksheet (nolock)
WHERE MediaWorksheetKey = @MediaWorksheetKey

IF ISNULL(@MediaOrderKey, 0) > 0
	BEGIN --Existing MediaOrder
		SELECT
			@OrderNumber = RTRIM(LTRIM(OrderNumber)),
			@CurrentRevision = Revision
		FROM tMediaOrder (nolock)
		WHERE MediaOrderKey = @MediaOrderKey
		
		IF ISNULL(@Revision, @CurrentRevision) != @CurrentRevision
			UPDATE tMediaOrder
			SET Revision = @Revision
			WHERE MediaOrderKey = @MediaOrderKey
		
		IF ISNULL(@PurchaseOrderKey, 0) > 0
			UPDATE tPurchaseOrder
			SET
				MediaOrderKey = @MediaOrderKey,
				PurchaseOrderNumber = RTRIM(LTRIM(@OrderNumber))
			WHERE PurchaseOrderKey = @PurchaseOrderKey
	END --Existing MediaOrder
ELSE
	BEGIN --No existing MediaOrder
		EXEC spGetNextTranNo @CompanyKey, @TranType, @Status OUTPUT, @OrderNumber OUTPUT
		
		IF @Status = 1
			BEGIN --New OrderNumber
				INSERT INTO tMediaOrder
					(
						MediaWorksheetKey,
						OrderNumber,
						Revision
					)
				VALUES
					(
						@MediaWorksheetKey,
						RTRIM(LTRIM(@OrderNumber)),
						0
					)
				
				SELECT @MediaOrderKey = SCOPE_IDENTITY()
				
				UPDATE tPurchaseOrder
				SET
					MediaOrderKey = @MediaOrderKey,
					PurchaseOrderNumber = RTRIM(LTRIM(@OrderNumber))
				WHERE PurchaseOrderKey = @PurchaseOrderKey
			END --New OrderNumber
	END --No existing MediaOrder

RETURN @MediaOrderKey
GO
