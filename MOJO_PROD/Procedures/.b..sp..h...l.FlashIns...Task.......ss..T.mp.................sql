USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleFlashInsertTaskPredecessorTemp]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleFlashInsertTaskPredecessorTemp]
	(
	@TaskPredecessorKey int,
	@TaskKey int,
	@PredecessorKey int,
	@Type varchar(10),
	@Lag int
	)

AS -- Encrypt

	SET NOCOUNT ON
	
	DECLARE @Action INT -- 1 Insert, 2 Update, 3 Delete
	IF @TaskPredecessorKey < 0 
		SELECT @Action = 1
	ELSE
		SELECT @Action = 2
		
	INSERT #tTaskPredecessor
		(
		TaskPredecessorKey,
		TaskKey,
		PredecessorKey,
		Type,
		Lag,
		Action
		)

	VALUES
		(
		@TaskPredecessorKey,
		@TaskKey,
		@PredecessorKey,
		@Type,
		@Lag,
		@Action
		)
		
	RETURN 1
GO
