USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetDemoUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaWorksheetDemoUpdate]
	@MediaWorksheetDemoKey int,
	@MediaWorksheetKey int,
	@MediaDemographicKey int,
	@DemoType varchar(10),
	@DisplayOrder int
AS

/*
|| When      Who Rel      What
|| 2/5/14    CRG 10.5.7.7 Created
*/

	IF @MediaWorksheetDemoKey > 0
		UPDATE	tMediaWorksheetDemo
		SET		MediaWorksheetKey = @MediaWorksheetKey,
				MediaDemographicKey = @MediaDemographicKey,
				DemoType = @DemoType,
				DisplayOrder = @DisplayOrder
		WHERE	MediaWorksheetDemoKey = @MediaWorksheetDemoKey
	ELSE
	BEGIN
		INSERT	tMediaWorksheetDemo
				(MediaWorksheetKey,
				MediaDemographicKey,
				DemoType,
				DisplayOrder)
		VALUES	(@MediaWorksheetKey,
				@MediaDemographicKey,
				@DemoType,
				@DisplayOrder)
		
		SELECT @MediaWorksheetDemoKey = @@IDENTITY
	END
	
	RETURN @MediaWorksheetDemoKey
GO
