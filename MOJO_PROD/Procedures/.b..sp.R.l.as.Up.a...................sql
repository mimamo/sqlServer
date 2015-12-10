USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReleaseUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReleaseUpdate]
	@ReleaseKey int,
	@ReleaseID varchar(50),
	@DateInstalled datetime,
	@LogText text
AS --Encrypt


	IF EXISTS (SELECT NULL FROM tRelease (NOLOCK) WHERE ReleaseKey = @ReleaseKey)
		UPDATE	tRelease
		SET		ReleaseID = @ReleaseID,
				DateInstalled = @DateInstalled,
				LogText = @LogText
		WHERE	ReleaseKey = @ReleaseKey
	ELSE
		INSERT	tRelease
				(ReleaseKey, 
				ReleaseID, 
				DateInstalled, 
				LogText)
		VALUES	(@ReleaseKey, 
				@ReleaseID, 
				@DateInstalled, 
				@LogText)
GO
