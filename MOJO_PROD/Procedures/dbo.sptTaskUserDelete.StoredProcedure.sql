USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserDelete]
	@TaskKey int

AS --Encrypt

	DELETE
	FROM tTaskUser
	WHERE
		TaskKey = @TaskKey 

	RETURN 1
GO
