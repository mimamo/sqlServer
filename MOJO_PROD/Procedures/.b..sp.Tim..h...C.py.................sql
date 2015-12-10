USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetCopy]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetCopy]
	(
		@CopyTimeSheetKey INT,
		@CompanyKey int,
		@UserKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@DateCreated smalldatetime,
		@oIdentity INT OUTPUT
	)
AS -- Encrypt


/*
|| When      Who Rel      What
|| 8/26/09   GWG 10.5.0.8 Modified the signature for calling timesheet insert
|| 3/08/11   RLB 10.5.4.2 (105267) Remove any task that are 100% complete unless they have the right to charge time to completed tasks
|| 10/11/11  RLB 10.5.4.9 (123353) Added a check for Admin or Charge any project on the Delete if user not assigned
*/

	SET NOCOUNT ON
	
	DECLARE @NewTimeSheetKey INT
			,@RetVal INT
			,@TimeEntriesCount INT
			,@SecurityGroupKey INT
			,@Administrator TINYINT
	
	Select @SecurityGroupKey = SecurityGroupKey,  @Administrator = ISNULL(Administrator, 0)  from tUser Where UserKey = @UserKey							
	-- Create a new time sheet		
	EXEC @NewTimeSheetKey = sptTimeSheetInsert @CompanyKey, @UserKey, @StartDate, @EndDate,
		1, NULL, @DateCreated, NULL, NULL
		
	IF @NewTimeSheetKey IS NULL
	BEGIN
		DELETE #tTime
		WHERE  TimeSheetKey = @CopyTimeSheetKey
	
		IF (SELECT COUNT(*) FROM #tTime) = 0 
			DROP TABLE #tTime
	
		RETURN -1
	END

	if (@Administrator = 0) And  not exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90920 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey)
	Begin
		DELETE #tTime
		FROM tTask t (nolock)
		WHERE  #tTime.TimeSheetKey = @CopyTimeSheetKey
		AND #tTime.TaskKey = t.TaskKey
		AND t.PercComp = 100
	END

	-- Delete if the project status does not allow time entries or project closed
	DELETE #tTime
	FROM   tProject p (nolock)
		   LEFT OUTER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey	
	WHERE  #tTime.TimeSheetKey = @CopyTimeSheetKey
	AND    #tTime.ProjectKey = p.ProjectKey
	AND    (ps.TimeActive = 0 OR p.Closed = 1)
	
	-- Delete if the user is not assigned to it
	if (@Administrator = 0) And  not exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90919 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey)
	BEGIN
	
		DELETE #tTime
		WHERE  TimeSheetKey = @CopyTimeSheetKey
		AND    ProjectKey NOT IN (SELECT ProjectKey FROM tAssignment (NOLOCK) WHERE UserKey = @UserKey)

	END
	
								
	-- Delete if WorkDate > tTimeSheet.EndDate
	DELETE #tTime
	WHERE  TimeSheetKey = @CopyTimeSheetKey
	AND    WorkDate > @EndDate

	-- Delete if WorkDate < tTimeSheet.StartDate
	DELETE #tTime
	WHERE  TimeSheetKey = @CopyTimeSheetKey
	AND    WorkDate < @StartDate
								
	SELECT @TimeEntriesCount = COUNT(*) FROM #tTime WHERE TimeSheetKey = @CopyTimeSheetKey
	
	
	-- Request by General Learning to copy 0 hours (2/13/2006)
	UPDATE #tTime
	SET	   ActualHours = 0
		  ,PauseHours = 0
		  ,StartTime = null
		  ,EndTime = null	
	WHERE  TimeSheetKey = @CopyTimeSheetKey
	
	IF @TimeEntriesCount > 0
	BEGIN			
		-- Now replace the TimeSheetKey in temp table
		UPDATE #tTime SET TimeSheetKey = @NewTimeSheetKey WHERE TimeSheetKey = @CopyTimeSheetKey 
				
		-- insert time entries
		-- sptTimeInsertMultiple will drop #tTime
		EXEC @RetVal = sptTimeInsertMultiple @NewTimeSheetKey
		
		IF @RetVal <> 1
		BEGIN
			EXEC sptTimeSheetDelete @NewTimeSheetKey
			RETURN -1		
		END
		
	END
	
	SELECT @oIdentity = @NewTimeSheetKey
	
	RETURN 1
GO
