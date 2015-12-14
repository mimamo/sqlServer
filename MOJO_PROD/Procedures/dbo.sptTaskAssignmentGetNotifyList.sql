USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGetNotifyList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGetNotifyList]

	(
		@ProjectKey int,
		@TaskKey int
	)

AS --Encrypt

Select Distinct
	u.UserKey,
	u.FirstName,
	u.LastName,
	u.Email
From
	tTask t (nolock)
	inner join tTaskAssignmentTypeService tats (nolock) on t.TaskAssignmentTypeKey = tats.TaskAssignmentTypeKey
	inner join (Select UserKey, ServiceKey from tProjectUserServices (nolock) Where ProjectKey = @ProjectKey) as ps on tats.ServiceKey = ps.ServiceKey
	inner join tUser u (nolock) on ps.UserKey = u.UserKey
Where
	t.TaskKey = @TaskKey and tats.Notify = 1
GO
