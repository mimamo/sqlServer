USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimelineSegmentUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimelineSegmentUpdate]
	@TimelineSegmentKey int,
	@CompanyKey int,
	@SegmentName varchar(200),
	@SegmentColor int,
	@DisplayName varchar(200),
	@Description varchar(max) = null
AS

/*
|| When      Who Rel      What
|| 10/19/10  CRG 10.5.3.7 Created
|| 03/31/15  GHL 10.5.9.1 (250966) Added Description for an enhancement for Kohl's
*/

	IF @TimelineSegmentKey <= 0
	BEGIN
		INSERT	tTimelineSegment
				(CompanyKey,
				SegmentName,
				SegmentColor,
				DisplayName,
				Description
				)
		VALUES	(@CompanyKey,
				@SegmentName,
				@SegmentColor,
				@DisplayName,
				@Description
				)

		RETURN @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE	tTimelineSegment
		SET		CompanyKey = @CompanyKey,
				SegmentName = @SegmentName,
				SegmentColor = @SegmentColor,
				DisplayName = @DisplayName,
				Description = @Description
		WHERE	TimelineSegmentKey = @TimelineSegmentKey

		RETURN @TimelineSegmentKey
	END
GO
