USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReleaseGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReleaseGet]
	@ReleaseKey int
AS --Encrypt

	SELECT	*
	FROM	tRelease (NOLOCK)
	WHERE	ReleaseKey = @ReleaseKey
GO
