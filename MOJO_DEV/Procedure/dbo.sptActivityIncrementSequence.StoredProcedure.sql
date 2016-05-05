USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityIncrementSequence]    Script Date: 04/29/2016 16:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptActivityIncrementSequence]
	@ActivityKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 6/18/09   CRG 10.5.0.0 Created to increment the sequence in tActivity for CalDAV.
*/

	DECLARE	@Sequence int
	
	SELECT	@Sequence = Sequence
	FROM	tActivity (NOLOCK)
	WHERE	ActivityKey = @ActivityKey
	
	SELECT	@Sequence = ISNULL(@Sequence, 0) + 1
	
	UPDATE	tActivity
	SET		Sequence = @Sequence
	WHERE	ActivityKey = @ActivityKey