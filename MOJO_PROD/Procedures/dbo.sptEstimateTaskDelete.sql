USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskDelete]
	@EstimateTaskKey int

AS --Encrypt

	DELETE
	FROM tEstimateTask
	WHERE
		EstimateTaskKey = @EstimateTaskKey 

	RETURN 1
GO
