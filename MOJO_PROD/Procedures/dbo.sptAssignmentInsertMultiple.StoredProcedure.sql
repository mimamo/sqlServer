USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentInsertMultiple]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentInsertMultiple]
	(
	@ProjectKey int
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 09/24/10 GHL 10.535   Creation for updates of the project team in the schedule module  
  ||                       Basically a clone of what is done about tAssignment in spScheduleFlashSaveWMJ  
  || 12/15/11 GWG 10.5.5.1 Added handling of defaults for subscribing and deliverable review and notify
  ||                    
  */

	SET NOCOUNT ON

/* Assume done in VB
	
	 ' Assignments or Project Assigned Users
                sSQL = "create table #tAssignment ( "
                sSQL &= "AssignmentKey int null"
                sSQL &= ", UserKey int null"
                sSQL &= ", HourlyRate money null"
                sSQL &= ", Action int null)" ' Action Code 1 insert, 2 update, 3 delete

                ' Assignments or Project Assigned Users
                sSQL = "create table #NewKeys ( "
                sSQL &= "Entity VARCHAR(50) null"
                sSQL &= ", OldKey int null"
                sSQL &= ", NewKey int null)"

*/
	

	-- Deletes
	DELETE tAssignment
	FROM   #tAssignment
	WHERE  tAssignment.ProjectKey = @ProjectKey 
	AND    tAssignment.UserKey = #tAssignment.UserKey
	AND    #tAssignment.Action = 3	

	-- Inserts 
	UPDATE #tAssignment
	SET    #tAssignment.HourlyRate = ISNULL(tUser.HourlyRate, 0)
	FROM   tUser (NOLOCK)
	WHERE  #tAssignment.UserKey = tUser.UserKey
	AND    #tAssignment.Action = 1

	-- Before inserting, check if already there
	UPDATE #tAssignment
	SET    #tAssignment.Action = 4 -- do not process 
	FROM   tAssignment (NOLOCK)
	WHERE  tAssignment.ProjectKey = @ProjectKey 
	AND    tAssignment.UserKey = #tAssignment.UserKey 
	
	INSERT tAssignment(ProjectKey,UserKey,HourlyRate)
	SELECT DISTINCT @ProjectKey, UserKey, HourlyRate
	FROM   #tAssignment
	WHERE  #tAssignment.Action = 1

	-- protection against duplicates
	DELETE tAssignment
	WHERE  tAssignment.ProjectKey = @ProjectKey
	AND    tAssignment.AssignmentKey > (SELECT MIN(a2.AssignmentKey) FROM tAssignment a2 (NOLOCK)
							WHERE  a2.ProjectKey = @ProjectKey
							AND    a2.UserKey = tAssignment.UserKey)
		
	-- protection against missing users (Bug 8250)
	-- not sure why, but it happened at Media Logic
	INSERT tAssignment (ProjectKey, UserKey, HourlyRate, SubscribeDiary, SubscribeToDo, DeliverableReviewer, DeliverableNotify)
	SELECT DISTINCT @ProjectKey, tu.UserKey, u.HourlyRate, u.SubscribeDiary, u.SubscribeToDo, u.DeliverableReviewer, u.DeliverableNotify
	FROM   tTaskUser tu (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
	WHERE t.ProjectKey = @ProjectKey
	AND   tu.UserKey NOT IN (SELECT UserKey FROM tAssignment (NOLOCK) WHERE ProjectKey = @ProjectKey)
		
	-- For returns to Flash
	INSERT #NewKeys (Entity, OldKey, NewKey)
	SELECT 'tAssignment', AssignmentKey, AssignmentKey
	FROM   #tAssignment
	WHERE  Action = 1
	
	UPDATE #NewKeys
	SET    #NewKeys.NewKey = b.AssignmentKey 
	FROM   #tAssignment a
	       ,tAssignment b (NOLOCK)  
	WHERE  a.AssignmentKey = #NewKeys.OldKey
	AND    b.ProjectKey = @ProjectKey
	AND    a.UserKey = b.UserKey
	AND    #NewKeys.Entity = 'tAssignment'
	


	RETURN 1
GO
