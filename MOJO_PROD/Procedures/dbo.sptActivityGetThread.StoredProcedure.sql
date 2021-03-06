USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetThread]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetThread]
	(
	@ActivityKey int,
	@UserKey int = 0
	)

AS

/*
|| When      Who Rel      What
|| 01/11/11  MFT 10.5.4.0 Added tTask, tUser (AddedByKey), DateAdded, ActivityEntity
|| 01/11/11  MFT 10.5.4.0 Added ProjectKey, VisibleToClient
|| 01/12/12  RLB 10.5.5.2 (131410) Added TaskKey for ToDo's
|| 02/01/13  WDF 10.5.6.4 (166313) Changed tUserLead join
|| 09/04/13  RLB 10.5.7.2 (187731) Adding ActivityTypeName for enhancement
|| 08/29/14  QMD 10.5.8.3 Added DateUpdated
|| 09/03/14  KMC 10.5.8.3 (227029) Added OriginatorName
|| 09/05/14  MFT 10.5.8.4 Added SortDate to match override in other queries
|| 02/19/15  RLB 10.5.8.9 Added UserKey so it came used to get replies in platinum
|| 02/25/15  QMD 10.5.8.9 Added a.AddedByKey 
*/

declare @RootActivityKey int
Select @RootActivityKey = RootActivityKey from tActivity (nolock) Where ActivityKey = @ActivityKey

	IF @UserKey > 0
	BEGIN
		Select	a.ActivityKey as EntityKey,
				'Activity' as Entity,
				'menuCMActivities' as IconStyle,
				a.ActivityKey,
				a.ParentActivityKey,
				a.Private,
				a.AssignedUserKey,
				a.OriginatorUserKey,
				a.ContactCompanyKey,
				a.ContactKey,
				a.LeadKey,
				a.ActivityDate,
				a.Completed,
				a.DateCompleted,
				a.Subject,
				a.Notes,
				u.FirstName + ' ' + u.LastName as AssignedUserName,
				con.FirstName + ' ' + con.LastName as ContactName,
				o.FirstName + ' ' + o.LastName as OriginatorName,
				ul.FirstName + ' ' + ul.LastName as LeadName,
				c.CompanyName as CompanyName,
				l.Subject as OpportunityName,
				p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
				t.TaskName,
				t.TaskKey,
				ab.FirstName + ' ' + ab.LastName as AddedByUserName,
				a.DateAdded,
				a.ActivityEntity,
				a.StartTime,
				a.EndTime,
				p.ProjectKey,
				a.VisibleToClient,
				a.UpdatedByKey,
				u2.FirstName + ' ' + u2.LastName as UpdatedUserName,
				att.TypeName,
				a.DateUpdated,
				0 as ReplyCount,
				
				(
				SELECT COUNT(*)
				FROM tActivity a4 (nolock) LEFT JOIN tAppRead ar (nolock) ON ar.Entity = 'tActivity' AND a4.ActivityKey = ar.EntityKey
				WHERE ISNULL(ar.IsRead, 0) = 0 AND a.ActivityKey = a4.RootActivityKey AND ISNULL(ar.UserKey, @UserKey) = @UserKey
				) AS UnreadCount,
				ISNULL(a.ActivityDate, ISNULL(a.DateAdded, a.DateUpdated)) as SortDate,
				a.AddedByKey
		From tActivity a (nolock)
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
		left outer join tUser con (nolock) on a.ContactKey = con.UserKey
		left outer join tUser o (nolock) on a.OriginatorUserKey = o.UserKey
		left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
		left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
		left outer join tLead l (nolock) on a.LeadKey = l.LeadKey
		left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
		left outer join tUser ab (nolock) on a.AddedByKey = ab.UserKey
		left outer join tUser u2 (nolock) on a.UpdatedByKey = u2.UserKey
		left outer join tActivityType att (nolock) on a.ActivityTypeKey = att.ActivityTypeKey
		Where a.RootActivityKey = @RootActivityKey
		Order By ParentActivityKey, ActivityDate, a.DateUpdated
	
	END
	ELSE
	BEGIN
		Select	a.ActivityKey as EntityKey,
				'Activity' as Entity,
				'menuCMActivities' as IconStyle,
				a.ActivityKey,
				a.ParentActivityKey,
				a.Private,
				a.AssignedUserKey,
				a.OriginatorUserKey,
				a.ContactCompanyKey,
				a.ActivityDate,
				a.Completed,
				a.DateCompleted,
				a.Subject,
				a.Notes,
				u.FirstName + ' ' + u.LastName as AssignedUserName,
				con.FirstName + ' ' + con.LastName as ContactName,
				o.FirstName + ' ' + o.LastName as OriginatorName,
				ul.FirstName + ' ' + ul.LastName as LeadName,
				c.CompanyName as CompanyName,
				l.Subject as OpportunityName,
				p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
				t.TaskName,
				t.TaskKey,
				ab.FirstName + ' ' + ab.LastName as AddedByUserName,
				a.DateAdded,
				a.ActivityEntity,
				p.ProjectKey,
				a.VisibleToClient,
				a.UpdatedByKey,
				u2.FirstName + ' ' + u2.LastName as UpdatedUserName,
				att.TypeName,
				a.DateUpdated,
				ISNULL(a.ActivityDate, ISNULL(a.DateAdded, a.DateUpdated)) as SortDate
		From tActivity a (nolock)
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
		left outer join tUser con (nolock) on a.ContactKey = con.UserKey
		left outer join tUser o (nolock) on a.OriginatorUserKey = o.UserKey
		left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
		left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
		left outer join tLead l (nolock) on a.LeadKey = l.LeadKey
		left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
		left outer join tUser ab (nolock) on a.AddedByKey = ab.UserKey
		left outer join tUser u2 (nolock) on a.UpdatedByKey = u2.UserKey
		left outer join tActivityType att (nolock) on a.ActivityTypeKey = att.ActivityTypeKey
		Where a.RootActivityKey = @RootActivityKey
		Order By ParentActivityKey, ActivityDate, a.DateUpdated
	
	END
GO
