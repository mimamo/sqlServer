USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetSummaryList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetSummaryList]

	(
		@ProjectKey int
	)
AS --Encrypt

	Select * from tTask (nolock)
	Where ProjectKey = @ProjectKey
	Order By PlanStart
GO
