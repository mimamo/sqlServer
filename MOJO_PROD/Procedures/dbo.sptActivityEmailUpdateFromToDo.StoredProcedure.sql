USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityEmailUpdateFromToDo]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityEmailUpdateFromToDo]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 12/13/10  CRG 10.5.3.9 Created for new ToDo screen
|| 2/22/11   CRG 10.5.4.1 Replaced RETURN with BREAK in the two loops below...my mistake
*/

	/* Assume crerated in VB
	CREATE TABLE #UserKeys (UserKey int NULL)
	*/

	--Get a list of all activities for this root (all child activities will get the same Email To list as the root)
	SELECT	ActivityKey
	INTO	#ActivityKeys
	FROM	tActivity (nolock)
	WHERE	RootActivityKey = @ActivityKey

	DELETE	tActivityEmail
	WHERE	ActivityKey IN (SELECT ActivityKey FROM #ActivityKeys)
	AND		UserKey NOT IN (SELECT UserKey FROM #UserKeys)
	AND		UserLeadKey IS NULL --Just in case there's a link to a Lead
	
	DECLARE	@LoopActivityKey int,
			@LoopUserKey int
	
	SELECT	@LoopActivityKey = 0

	WHILE (1=1)
	BEGIN
		SELECT	@LoopActivityKey = MIN(ActivityKey)
		FROM	#ActivityKeys
		WHERE	ActivityKey > @LoopActivityKey

		IF @LoopActivityKey IS NULL
			BREAK

		SELECT	@LoopUserKey = 0
	
		WHILE (1=1)
		BEGIN
			SELECT	@LoopUserKey = MIN(UserKey)
			FROM	#UserKeys
			WHERE	UserKey > @LoopUserKey

			IF @LoopUserKey IS NULL
				BREAK

			EXEC sptActivityEmailUpdate @LoopActivityKey, @LoopUserKey, null, 'insert'
		END	
	END
GO
