USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDoByName]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDoByName]
	@Subject VARCHAR(2500),
	@CompanyKey INT,
	@TaskKey INT
AS

/*
|| When      Who Rel      What
|| 04/30/14  QMD 10.5.7.9 Created for the API
||                        
*/

	SELECT	a.ActivityKey,
			a.DateUpdated,
			a.Private,
			a.AssignedUserKey,
			a.OriginatorUserKey,
			a.RootActivityKey,
			a.ParentActivityKey,
			a.ActivityDate,
			a.Completed,
			a.DateCompleted,
			a.Subject,
			a.ProjectKey,
			a.TaskKey,
			a.Notes,
			a.VisibleToClient,
			a.CustomFieldKey	
	FROM	tActivity a (NOLOCK)		
	WHERE	UPPER(a.Subject) = UPPER(@Subject)
			AND a.CompanyKey = @CompanyKey
			AND a.TaskKey = @TaskKey
			AND a.ActivityEntity = 'ToDo'
GO
