USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetDemoGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaWorksheetDemoGet]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 2/5/14    CRG 10.5.7.7 Created
*/

	SELECT demo.*, md.DemographicID, md.DemographicName
	FROM	tMediaWorksheetDemo demo (NOLOCK)
	LEFT JOIN tMediaDemographic md (NOLOCK) ON demo.MediaDemographicKey = md.MediaDemographicKey
	WHERE	demo.MediaWorksheetKey = @MediaWorksheetKey
	ORDER BY demo.DisplayOrder
GO
