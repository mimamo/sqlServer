USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReleaseUpdateDateInstalled]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReleaseUpdateDateInstalled]
	@ReleaseKey int,
	@ReleaseID varchar(50),
	@DateInstalled datetime
AS --Encrypt

	IF EXISTS(SELECT NULL FROM tRelease (NOLOCK) WHERE ReleaseKey = @ReleaseKey)
		UPDATE	tRelease
		SET		DateInstalled = @DateInstalled
		WHERE	ReleaseKey = @ReleaseKey
	ELSE
		INSERT	tRelease
				(ReleaseKey,
				ReleaseID,
				DateInstalled)
		VALUES	(@ReleaseKey,
				@ReleaseID,
				@DateInstalled)
GO
