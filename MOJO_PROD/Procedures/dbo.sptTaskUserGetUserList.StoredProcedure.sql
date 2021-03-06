USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetUserList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetUserList]
	@TaskKey int


AS --Encrypt

	 
	SELECT	d.DepartmentName
			,u1.UserKey
			,u1.FirstName + ' ' + u1.LastName AS UserName
			,(SELECT COUNT(*) 
			FROM tTaskUser tau (NOLOCK) 
			WHERE tau.TaskKey = @TaskKey 
			AND   tau.UserKey = u1.UserKey
			)As Assigned		 
			,ISNULL((SELECT SUM(Hours) 
			FROM tTaskUser tau (NOLOCK) 
			WHERE tau.TaskKey = @TaskKey 
			AND   tau.UserKey = u1.UserKey
			), 0) As Hours
			,isnull((select SUM(PercComp) from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			),0) as PercComp
			-- We can only have 1 result in a subquery
			,(select top 1 ActStart from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			) as ActStart
			,(select top 1 ActComplete from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			) as ActComplete
			,isnull((select SUM(ReviewedByTraffic) from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			),0) as ReviewedByTraffic
			,(select top 1 ReviewedByDate from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			) as ReviewedByDate			
			,(select top 1 ReviewedByKey from tTaskUser tau (nolock)
			          where tau.TaskKey = @TaskKey 
			            and tau.UserKey = u1.UserKey
			) as ReviewedByKey			
	FROM	tTask  t (nolock)
			INNER JOIN tAssignment a (NOLOCK) ON t.ProjectKey = a.ProjectKey
			INNER JOIN tUser u1 (NOLOCK) ON a.UserKey = u1.UserKey
			LEFT OUTER JOIN tDepartment d (NOLOCK) ON u1.DepartmentKey = d.DepartmentKey
	WHERE	t.TaskKey = @TaskKey
	ORDER BY d.DepartmentName, Assigned DESC, u1.FirstName, u1.LastName
	
		
RETURN 1
GO
