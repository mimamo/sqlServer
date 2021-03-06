USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityIncrementSequence]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityIncrementSequence]
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
GO
