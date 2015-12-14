USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdateDuration]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdateDuration]
	(
		@TaskKey int,
		@Duration int
	)
AS

Update tTask Set PlanDuration = @Duration Where TaskKey = @TaskKey
GO
