USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskSetBaseline]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskSetBaseline]

	(
		@ProjectKey int
	)

AS --Encrypt

	Update tTask
	Set
		BaseStart = PlanStart,
		BaseComplete = PlanComplete
	Where
		tTask.ProjectKey = @ProjectKey
GO
