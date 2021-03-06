USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetMarketGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaWorksheetMarketGet]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 2/6/14    CRG 10.5.7.7 Created
*/

	SELECT	wm.*, mm.MarketID, mm.MarketName
	FROM	tMediaWorksheetMarket wm (nolock)
	INNER JOIN tMediaMarket mm (nolock) ON wm.MediaMarketKey = mm.MediaMarketKey
	WHERE	wm.MediaWorksheetKey = @MediaWorksheetKey
	ORDER BY mm.MarketID
GO
