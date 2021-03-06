USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableGetAssignments]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptReviewDeliverableGetAssignments]
(
	@ReviewDeliverableKey int
)

as


Select u.UserName, t.TaskName, tu.*
From
	tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	left outer join vUserName u (nolock) on tu.UserKey = u.UserKey
	Where tu.DeliverableKey = @ReviewDeliverableKey
	Order By t.PlanStart, t.ProjectOrder
GO
