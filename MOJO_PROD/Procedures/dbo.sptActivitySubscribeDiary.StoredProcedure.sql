USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivitySubscribeDiary]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivitySubscribeDiary]
	@ActivityKey int,
	@UserKey int,
	@Unsubscribe tinyint = 0
AS

/*
|| When      Who Rel      What
|| 12/14/10  RLB 10.5.3.9 Created to subscribe to Diaries. Only want to remove user from parent not the whole thread for tracking emails
*/

	SELECT	ActivityKey
	INTO	#ActivityKeys
	FROM	tActivity (nolock)
	WHERE	ActivityKey = @ActivityKey

	DECLARE	@Action varchar(15)
	IF @Unsubscribe = 1
		SELECT	@Action = 'delete'
	ELSE
		SELECT	@Action = 'insert'

	DECLARE	@LoopKey int
	SELECT	@LoopKey = 0

	WHILE (1=1)
	BEGIN
		SELECT	@LoopKey = MIN(ActivityKey)
		FROM	#ActivityKeys
		WHERE	ActivityKey > @LoopKey

		IF @LoopKey IS NULL
			RETURN

		EXEC sptActivityEmailUpdate @LoopKey, @UserKey, null, @Action, 0
	END
GO
