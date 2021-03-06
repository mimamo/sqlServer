USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateNotifyDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateNotifyDelete]
	(
		@EstimateKey INT,
		@UserKey INT
	)
AS	-- Encrypt

	SET NOCOUNT ON
	
	DELETE tEstimateNotify
	WHERE  EstimateKey = @EstimateKey
	AND    UserKey = @UserKey
	 
	RETURN 1
GO
