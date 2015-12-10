USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivitySubscribe]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivitySubscribe]
	@ActivityKey int,
	@UserKey int,
	@Unsubscribe tinyint = 0
AS

/*
|| When      Who Rel      What
|| 12/14/10  CRG 10.5.3.9 Created to subscribe to Diaries and To Dos
*/

	SELECT	ActivityKey
	INTO	#ActivityKeys
	FROM	tActivity (nolock)
	WHERE	RootActivityKey = @ActivityKey

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

		EXEC sptActivityEmailUpdate @LoopKey, @UserKey, null, @Action
	END
GO
