USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetGetList]

	@CompanyKey int,
	@Active tinyint,
	@ItemRateSheetKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	if @Active is null
		SELECT *
		FROM tItemRateSheet (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By RateSheetName
	else
		SELECT	*
		FROM	tItemRateSheet (nolock)
		WHERE	CompanyKey = @CompanyKey 
		AND		(Active = @Active OR ItemRateSheetKey = @ItemRateSheetKey)
		Order By RateSheetName

	RETURN 1
GO
