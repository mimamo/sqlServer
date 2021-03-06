USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateNotifyGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateNotifyGetList]
	(
		@EstimateKey INT
	)
	
AS	-- Encrypt

	SET NOCOUNT ON
	
	SELECT en.EstimateKey, u.*
	FROM   tEstimateNotify en (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON en.UserKey = u.UserKey
	WHERE en.EstimateKey = @EstimateKey
		
	RETURN 1
GO
