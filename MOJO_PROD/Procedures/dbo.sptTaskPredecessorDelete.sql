USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskPredecessorDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskPredecessorDelete]
	@TaskPredecessorKey int

AS --Encrypt

	DELETE
	FROM tTaskPredecessor
	WHERE
		TaskPredecessorKey = @TaskPredecessorKey 

	RETURN 1
GO
