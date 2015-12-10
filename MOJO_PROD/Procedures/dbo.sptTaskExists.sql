USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskExists]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskExists]

	 @ProjectKey int
	,@TaskID varchar(30)

as --Encrypt

	IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey)
		RETURN -1

	RETURN 1
GO
