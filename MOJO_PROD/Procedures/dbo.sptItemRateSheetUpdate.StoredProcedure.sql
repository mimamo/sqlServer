USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetUpdate]
	@ItemRateSheetKey int,
	@CompanyKey int,
	@RateSheetName varchar(50),
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 01/25/10  RLB 10.5.1.7 Added insert logic
*/


IF @ItemRateSheetKey > 0

BEGIN

	UPDATE
		tItemRateSheet
	SET
		CompanyKey = @CompanyKey,
		RateSheetName = @RateSheetName,
		Active = @Active
	WHERE
		ItemRateSheetKey = @ItemRateSheetKey 
		RETURN @ItemRateSheetKey
END
ELSE
BEGIN
	INSERT tItemRateSheet
		(
		CompanyKey,
		RateSheetName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@RateSheetName,
		@Active
		)
	RETURN @@IDENTITY
END
GO
