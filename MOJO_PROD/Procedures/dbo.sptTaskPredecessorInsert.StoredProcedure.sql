USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskPredecessorInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskPredecessorInsert]
	@TaskKey int,
	@PredecessorKey int,
	@Type varchar(10),
	@Lag int,
	@oIdentity INT OUTPUT
AS --Encrypt

if exists(select 1 from tTaskPredecessor (NOLOCK) Where TaskKey = @TaskKey and PredecessorKey = @PredecessorKey)
	return -1 

	INSERT tTaskPredecessor
		(
		TaskKey,
		PredecessorKey,
		Type,
		Lag
		)

	VALUES
		(
		@TaskKey,
		@PredecessorKey,
		@Type,
		@Lag
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
