USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUserGetUserListForTA]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUserGetUserListForTA]
	@TaskKey int
	,@TaskAssignmentKey int
	,@AllocatedHoursOnly smallint


AS --Encrypt

/*
	Who	Rel		When		What
	GHL	8.3		04/24/06	When Allocated Hours Only case, pull users in tTaskAssignmentUser first then tTaskUser
							to prevent list to be blanked out when user changes Allocated Only checkbox on screen
							after saving list 
*/


	IF @AllocatedHoursOnly = 1
	BEGIN	
		-- Get the list of users in tTaskAssignmentUser
		SELECT	d.DepartmentName
				,u.UserKey
				,u.FirstName + ' ' + u.LastName AS UserName
				,1 As Assigned		 					
		FROM	tTaskAssignmentUser  tau (nolock)
				INNER JOIN tUser u (NOLOCK) ON tau.UserKey = u.UserKey
				LEFT OUTER JOIN tDepartment d (NOLOCK) ON u.DepartmentKey = d.DepartmentKey
		WHERE	tau.TaskKey = @TaskKey
		AND		tau.TaskAssignmentKey = @TaskAssignmentKey
		
		UNION ALL
		
		-- Get the list of users in tTaskUser and not in tTaskAssignmmtUser 
		SELECT	d.DepartmentName
				,u.UserKey
				,u.FirstName + ' ' + u.LastName AS UserName
				,0 As Assigned		 
		FROM	tTaskUser  tu (nolock)
				INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
				LEFT OUTER JOIN tDepartment d (NOLOCK) ON u.DepartmentKey = d.DepartmentKey
		WHERE	tu.TaskKey = @TaskKey
		AND     tu.UserKey NOT IN (SELECT UserKey FROM tTaskAssignmentUser (NOLOCK) 
								   WHERE TaskKey = @TaskKey
								   AND   TaskAssignmentKey = @TaskAssignmentKey
								   )					
	
		ORDER BY d.DepartmentName, Assigned DESC, UserName
	END
	
	ELSE
	
		SELECT	d.DepartmentName
				,u.UserKey
				,u.FirstName + ' ' + u.LastName AS UserName
				,(SELECT COUNT(*) 
				FROM tTaskAssignmentUser tau (NOLOCK) 
				WHERE tau.TaskKey = @TaskKey 
				AND   tau.TaskAssignmentKey = @TaskAssignmentKey
				AND   tau.UserKey = u.UserKey
				)As Assigned		 
		FROM	tAssignment a (nolock)
				INNER JOIN tProject p (NOLOCK) ON a.ProjectKey = p.ProjectKey
				INNER JOIN tTask t (NOLOCK) ON p.ProjectKey = t.ProjectKey
				INNER JOIN tUser u (NOLOCK) ON a.UserKey = u.UserKey
				LEFT OUTER JOIN tDepartment d (NOLOCK) ON u.DepartmentKey = d.DepartmentKey
		WHERE	t.TaskKey = @TaskKey
		ORDER BY d.DepartmentName, Assigned DESC, u.FirstName, u.LastName
	
		
RETURN 1
GO
