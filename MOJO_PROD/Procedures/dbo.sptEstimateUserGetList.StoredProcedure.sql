USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUserGetList]

	@EstimateKey int


AS --Encrypt

/*
  || When     Who Rel   What
  || 04/23/10 RLB 10.521 (79222) wrapped UserName and UserInitials with isnull
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  ||                    
  */

declare @ProjectKey int

Select @ProjectKey = ProjectKey from tEstimate (nolock) Where EstimateKey = @EstimateKey

SELECT 
	@ProjectKey as ProjectKey,
	eu.*,
	ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
	ISNULL(left(u.FirstName, 1), '') + ISNULL(left(u.LastName, 1), '') as UserInitials,
	ISNULL((Select Sum(Hours) from tEstimateTaskLabor etl (nolock) Where etl.EstimateKey = @EstimateKey and etl.UserKey = eu.UserKey), 0) as TotalHours,
	ISNULL((Select Sum(Round(Hours * Rate,2)) from tEstimateTaskLabor etl (nolock) Where etl.EstimateKey = @EstimateKey and etl.UserKey = eu.UserKey), 0) as TotalAmt

FROM tEstimateUser eu (nolock)
	inner join tUser u (nolock) on u.UserKey = eu.UserKey
WHERE
	EstimateKey = @EstimateKey
Order by u.LastName

	RETURN 1
GO
