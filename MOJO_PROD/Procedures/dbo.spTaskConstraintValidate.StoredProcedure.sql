USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskConstraintValidate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskConstraintValidate]

	(
		@TaskKey int
	)

AS --Encrypt

 /*
  || When     Who Rel     What
  || 08/01/13 RLB 10.570 (179533) added to check for any predecessors for new schedule constraint
  */
	if exists(Select 1 From tTaskPredecessor (nolock) Where TaskKey = @TaskKey)
		Return -1
	if exists(Select 1 From tTaskPredecessor (nolock) Where PredecessorKey = @TaskKey)
		Return -1
		
	Return 1
GO
