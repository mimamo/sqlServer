USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetGet]
	@ItemRateSheetKey int

AS --Encrypt

		SELECT *
		FROM tItemRateSheet (nolock)
		WHERE
			ItemRateSheetKey = @ItemRateSheetKey

	RETURN 1
GO
