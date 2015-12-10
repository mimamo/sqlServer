USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimelineSegmentDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimelineSegmentDelete]
	@TimelineSegmentKey int
AS

/*
|| When      Who Rel      What
|| 10/19/10  CRG 10.5.3.7 Created
*/

	UPDATE	tTask
	SET		TimelineSegmentKey = NULL
	WHERE	TimelineSegmentKey = @TimelineSegmentKey

	DELETE	tTimelineSegment
	WHERE	TimelineSegmentKey = @TimelineSegmentKey
GO
