USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spValidateProjectAndTask]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValidateProjectAndTask]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@ProjectRestriction tinyint,
	@UserKey int,
	@TaskID varchar(30),
	@TaskRestriction tinyint
	
AS  --Encrypt

/*
|| When      Who Rel     What
|| 8/15/07   CRG 8.5     (9833) Created to validate both Project and Task in one DB call, and return ProjectNumber, ProjectName, TaskID, and TaskName.
||                       It is used by f.ValidProjectTask.
|| 10/09/09 GHL 10.511   Added new parameter to sptProjectValidNumber
*/

	DECLARE	@ProjectKey int,
			@TaskKey int

	-- Validate project, pass AccountType = 0, i.e. check prjAccessAny right
	EXEC @ProjectKey = sptProjectValidNumber @CompanyKey, @ProjectNumber, @UserKey, @ProjectRestriction, 0
	
	IF @ProjectKey = 0
		RETURN -1 --Invalid Project

	IF ISNULL(@TaskID, '') = ''
	BEGIN
		SELECT	ProjectKey, ProjectNumber, ProjectName, NULL AS TaskKey, NULL AS TaskID, NULL AS TaskName
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey
	END
	ELSE
	BEGIN
		EXEC @TaskKey = spTaskIDValidate @TaskID, @ProjectKey, @TaskRestriction
		
		IF @TaskKey = -1
			RETURN -2 --Invalid Task

		SELECT	p.ProjectKey, p.ProjectNumber, p.ProjectName, t.TaskKey, t.TaskID, t.TaskName
		FROM	tProject p (nolock)
		INNER JOIN tTask t (nolock) ON p.ProjectKey = t.ProjectKey
		WHERE	TaskKey = @TaskKey
	END
	
	RETURN 1 --Everything is valid
GO
