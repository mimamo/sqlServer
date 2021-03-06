USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetBudgetGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaWorksheetBudgetGet]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 3/11/14   CRG 10.5.7.8 Created
*/

	DECLARE	@CompanyKey int,
			@POKind smallint
	
	SELECT	@CompanyKey = CompanyKey,
			@POKind = POKind
	FROM	tMediaWorksheet (nolock)
	WHERE	MediaWorksheetKey = @MediaWorksheetKey
	
	SELECT	i.ItemKey,
			ISNULL(i.ItemID, '') + '-' + ISNULL(i.ItemName, '') AS ItemName,
			mwb.Budget
	FROM	tItem i (nolock)
	LEFT JOIN tMediaWorksheetBudget mwb (nolock) ON i.ItemKey = mwb.ItemKey AND mwb.MediaWorksheetKey = @MediaWorksheetKey
	WHERE	i.CompanyKey = @CompanyKey
	AND		i.ItemType = @POKind
	ORDER BY i.ItemID, i.ItemName
GO
