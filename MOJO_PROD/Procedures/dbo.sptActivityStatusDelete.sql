USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityStatusDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityStatusDelete]
	@ActivityStatusKey int

AS

	DELETE
	FROM
		tActivityStatus
	WHERE
		ActivityStatusKey = @ActivityStatusKey
GO
