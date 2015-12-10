USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetHoursDetailAssign]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateGetHoursDetailAssign]

	(
		@EstimateKey int
	)

AS --Encrypt

Select etal.* 
from tEstimateTaskAssignmentLabor etal (nolock)
Where
	etal.EstimateKey = @EstimateKey
GO
