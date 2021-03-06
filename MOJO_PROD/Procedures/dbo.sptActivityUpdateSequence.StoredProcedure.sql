USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateSequence]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateSequence]
	@ActivityKey int,
	@Sequence int
AS

/*
|| When      Who Rel      What
|| 6/17/09   CRG 10.5.0.0 Created because when events are synced with CalDAV, their Sequence numbers may have already been defined.
*/

	UPDATE	tActivity
	SET		Sequence = @Sequence
	WHERE	ActivityKey = @ActivityKey
GO
