USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptActivityPrint]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptActivityPrint] 
	@ActivityKey int
	
AS -- Encrypt

/*
|| When     Who Rel     What
|| 06/15/11 RLB 10.545  Created for new Activity Print
*/


BEGIN
	SELECT	a.*,
			p.ProjectNumber + '-' + p.ProjectName as FullProjectName,
			ou.FirstName + ' ' + ou.LastName as Author,
			au.FirstName + ' ' + au.LastName as AssignedTo,
			t.TaskID + '-' + t.TaskName as FullTaskName,
			ISNULL(att.TypeName, 'Activity Snapshot') as ActivityType
	FROM tActivity a (nolock)
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tUser au (nolock) on a.AssignedUserKey = au.UserKey
	left outer join tUser ou (nolock) on a.OriginatorUserKey = ou.UserKey
	left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
	left outer join tActivityType att (nolock) on a.ActivityTypeKey = att.ActivityTypeKey
	WHERE ActivityKey = @ActivityKey
END
GO
