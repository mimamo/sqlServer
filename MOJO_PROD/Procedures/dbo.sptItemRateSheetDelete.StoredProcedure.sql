USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetDelete]
	@ItemRateSheetKey int

AS --Encrypt

if exists(Select 1 from tCompany (nolock) Where ItemRateSheetKey = @ItemRateSheetKey)
	Return -1

if exists(Select 1 from tProject (nolock) Where ItemRateSheetKey = @ItemRateSheetKey)
	Return -2

	DELETE
	FROM tItemRateSheetDetail
	WHERE
		ItemRateSheetKey = @ItemRateSheetKey 

	DELETE
	FROM tItemRateSheet
	WHERE
		ItemRateSheetKey = @ItemRateSheetKey 

	RETURN 1
GO
