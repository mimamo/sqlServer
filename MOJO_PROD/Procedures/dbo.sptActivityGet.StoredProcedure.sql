USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGet]
	(
	@ActivityKey int
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 07/13/10 GHL 10.532	 Creation for calendar my tasks
|| 9/1/10   CRG 10.5.3.4 Added AllDayEvent so that the checkbox will display properly
|| 9/8/10   CRG 10.5.3.5 Added ProjectNumber, ProjectName, TaskID, TaskName
|| 10/6/10  CRG 10.5.3.6 Changed join to tUser to left join because AssignedUserKey can be NULL sometimes
|| 11/5/10  CRG 10.5.3.7 Added Company and Contact information
|| 01/30/12 RLB 10.5.6.4 (166866) i need to wrap ProjectKey with ISNULL 
|| 06/15/13 GWG 10.5.6.9 Defaulting Activity Entity to Activity
|| 04/20/15 RLB 10.5.9.1 Added Signature for new activity email
*/

	SET NOCOUNT ON

	select	a.ActivityKey,
			a.CompanyKey,
			a.ParentActivityKey,
			a.Private,
			a.Type,
			a.Priority,
			a.Subject,
			a.ContactCompanyKey,
			a.ContactKey,
			a.UserLeadKey,
			a.LeadKey,
			ISNULL(a.ProjectKey, 0) as ProjectKey,
			a.StandardActivityKey,
			a.AssignedUserKey,
			a.OriginatorUserKey,
			a.CustomFieldKey,
			a.VisibleToClient,
			a.Outcome,
			a.ActivityDate,
			a.StartTime,
			a.EndTime,
			a.ReminderMinutes,
			a.ActivityTime,
			a.Completed,
			a.DateCompleted,
			a.Notes,
			a.AddedByKey,
			a.UpdatedByKey,
			a.DateAdded,
			a.DateUpdated,
			a.OldNoteKey,
			a.OldParentNoteKey,
			a.CMFolderKey,
			a.TaskKey,
			a.ActivityTypeKey,
			a.SubjectIndex,
			a.UID,
			a.Sequence,
			ISNULL(a.ActivityEntity, 'Activity') as ActivityEntity,
			a.DisplayOrder,
			a.GLCompanyKey,
			au.FirstName + ' ' + au.LastName  as AssignedUserName,
			CASE
				WHEN a.StartTime IS NULL THEN 1
				ELSE 0
			END AS AllDayEvent,
			p.ProjectNumber,
			p.ProjectName,
			t.TaskID,
			t.TaskName,
			con.FirstName + ' ' + con.LastName as ContactName,
			c.CompanyName,
			au.Signature
	from    tActivity a (nolock)
	    left join tUser au (nolock) on a.AssignedUserKey = au.UserKey 
		left join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		left join tTask t (nolock) on a.TaskKey = t.TaskKey
		left join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
		left join tUser con (nolock) on a.ContactKey = con.UserKey
	where   a.ActivityKey = @ActivityKey

	RETURN 1
GO
