USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdateComment]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdateComment]
	(
		@TaskKey int,
		@TaskStatusComments varchar(4000) = NULL 
	)
AS

/*
|| When     Who Rel      What
|| 05/09/14 MAS 10.5.7.9 (213457) Added For the new app
*/
Update tTask Set Comments = @TaskStatusComments Where TaskKey = @TaskKey
GO
