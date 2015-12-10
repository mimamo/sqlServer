USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskPredecessorUpdate]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskPredecessorUpdate]
	@TaskPredecessorKey int,
	@TaskKey int,
	@PredecessorKey int,
	@Type varchar(10),
	@Lag int

AS --Encrypt

if exists(select 1 from tTaskPredecessor (NOLOCK) Where TaskKey = @TaskKey and PredecessorKey = @PredecessorKey and TaskPredecessorKey <> @TaskPredecessorKey)
	return -1 

	UPDATE
		tTaskPredecessor
	SET
		TaskKey = @TaskKey,
		PredecessorKey = @PredecessorKey,
		Type = @Type,
		Lag = @Lag
	WHERE
		TaskPredecessorKey = @TaskPredecessorKey 

	RETURN 1
GO
