USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateNotifyInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateNotifyInsert]
	(
		@EstimateKey INT,
		@UserKey INT
	)
AS
	SET NOCOUNT ON
	
	IF EXISTS (SELECT 1 FROM tEstimateNotify (NOLOCK)
		WHERE EstimateKey = @EstimateKey
		AND   UserKey = @UserKey)
		RETURN 1
		
	INSERT tEstimateNotify (EstimateKey, UserKey)
	VALUES (@EstimateKey, @UserKey)
	
	RETURN 1
GO
