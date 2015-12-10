USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReleaseUpdateLogText]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReleaseUpdateLogText]
	@ReleaseKey int,
	@ReleaseID varchar(50),
	@LogText text
AS --Encrypt

	IF EXISTS(SELECT NULL FROM tRelease (NOLOCK) WHERE ReleaseKey = @ReleaseKey)
		UPDATE	tRelease
		SET		LogText = @LogText
		WHERE	ReleaseKey = @ReleaseKey
	ELSE
		INSERT	tRelease
				(ReleaseKey,
				ReleaseID,
				LogText)
		VALUES	(@ReleaseKey,
				@ReleaseID,
				@LogText)
GO
