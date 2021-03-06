USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentDelete]
 @ProjectKey int,
 @UserKey int
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/21/06 GHL 8.4   Added logic to allow deletion of duplicates in tAssignment
  */

DECLARE @Count INT
        ,@AssignmentKey INT
        
SELECT @Count = COUNT(*)
FROM   tAssignment (NOLOCK)
WHERE  UserKey = @UserKey
AND    ProjectKey = @ProjectKey 

IF @Count > 1 
BEGIN
	-- select one key, ANY key
	SELECT @AssignmentKey = AssignmentKey
	FROM   tAssignment (NOLOCK)
	WHERE  UserKey = @UserKey
	AND    ProjectKey = @ProjectKey 
	
	-- delete the other ones
	DELETE tAssignment 
	WHERE  UserKey = @UserKey
	AND    ProjectKey = @ProjectKey
	AND    AssignmentKey <> @AssignmentKey
END  
  
  
If exists(Select 1 
	from tTaskUser tu (nolock)
		inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	Where
		t.ProjectKey = @ProjectKey and tu.UserKey = @UserKey)
	return -1
	
if exists(Select 1 from tUser (nolock) Where UserKey = @UserKey and NoUnassign = 1)
	return -2
	
 DELETE tProjectUserServices
 WHERE
  ProjectKey = @ProjectKey and UserKey = @UserKey	
	
 DELETE
 FROM tAssignment
 WHERE
  ProjectKey = @ProjectKey and UserKey = @UserKey
  
  

 RETURN 1
GO
