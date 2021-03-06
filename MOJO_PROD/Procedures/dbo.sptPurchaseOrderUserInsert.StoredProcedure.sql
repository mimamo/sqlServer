USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUserInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderUserInsert]
	
	@PurchaseOrderKey int,
	@UserKey int,
	@NotificationSent smallint = NULL
	
AS --Encrypt
	/*
	|| When     Who Rel       What
	|| 09/08/10 MFT 10.5.3.5  Added NotificationSent
	|| 09/13/10 MFT 10.5.3.5  Added Error trapping
	*/
	
	IF @PurchaseOrderKey < 1 AND @UserKey < 1 RETURN -1
	IF EXISTS(
		SELECT
			*
		FROM
			tPurchaseOrderUser
		WHERE
			PurchaseOrderKey = @PurchaseOrderKey AND
			UserKey = @UserKey
	) RETURN -2
	
	INSERT tPurchaseOrderUser
		(
		PurchaseOrderKey,
		UserKey,
		NotificationSent
		)

	VALUES
		(
		@PurchaseOrderKey,
		@UserKey,
		@NotificationSent
		)
	
	RETURN 1
GO
