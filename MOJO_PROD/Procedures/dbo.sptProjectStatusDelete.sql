USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusDelete]
	@ProjectStatusKey int

AS --Encrypt
	IF EXISTS(
		SELECT 1
		FROM tProject (NOLOCK) 
		WHERE ProjectStatusKey = @ProjectStatusKey)
		RETURN -1

	DELETE
	FROM tProjectStatus
	WHERE
		ProjectStatusKey = @ProjectStatusKey 

	RETURN 1
GO
