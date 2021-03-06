USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDetail]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDetail]
	(
		@ActivityKey int
	)

AS

/*
|| When      Who Rel      What
|| 06/02/09  RTC 10.5.0.0 Added User Leads to email list
|| 06/17/09  CRG 10.5.0.0 Added assigned user's TimeZoneIndex for use by CalDAV.
|| 06/17/09  MAS 10.5.0.0 (56361) Added AssignedUserName and OriginatorUserName
|| 4/27/10   CRG 10.5.2.1 Added Campaign and Campaign Segment queries
|| 08/30/10  RLB 10.5.3.4 (88719) Added Activity count for an enhancement
|| 11/10/10  RLB 10.5.3.8 (94115) Pulling Cell instead of Phone2
|| 02/07/11  MFT 10.5.4.0 Added ClientVendorLogin, TimeZoneIndex
|| 02/21/11  GHL 10.5.4.1 Added protection against null emails
|| 06/22/12  GHL 10.5.5.7 Added gl company info
|| 09/05/14  MFT 10.5.8.4 Added SortDate to match override in other queries
|| 10/23/14  RLB 10.5.8.5 Added counts for tabs in Platinum
|| 10/30/14  RLB 10.5.8.5 Added Editable flag on Emails for Plat and check for parent activty
|| 02/11/15  RLB 10.5.8.9 Added company phone, contact phone and contact email for plat
*/

Declare @CurrentRootActivityKey int, @ParentActivityKey int

select @CurrentRootActivityKey = RootActivityKey, @ParentActivityKey = ParentActivityKey  from tActivity (nolock) where ActivityKey = @ActivityKey

Select a.*,
	ISNULL(a.ActivityDate, ISNULL(a.DateAdded, a.DateUpdated)) as SortDate,
	c.CompanyName,
	c.Phone as CompanyPhone,
	c.AccountManagerKey as CompanyOwnerKey,
	c.CMFolderKey as CompanyFolderKey,
	
	con.FirstName + ' ' + con.LastName as ContactName,
	con.Phone1 as ContactPhone,
	con.Email as ContactEmail,
	con.OwnerKey as ContactOwnerKey,
	con.CMFolderKey as ContactFolderKey,
	
	ul.FirstName + ' ' + ul.LastName as UserLeadName,
	ul.Title as UserLeadTitle,
	ul.CompanyName as UserLeadCompany,
	ul.OwnerKey as LeadOwnerKey,
	ul.CMFolderKey as LeadFolderKey,
	
	l.Subject as OpportunitySubject,
	l.AccountManagerKey as OpportunityOwnerKey,
	l.CMFolderKey as OpportunityFolderKey,
	(select count(*) from tActivity (nolock) where RootActivityKey = @CurrentRootActivityKey) as ActivityCount,
	(select count(*) from tActivity rca (nolock) where rca.ParentActivityKey = a.ActivityKey) as ReplyCount,
	(select count(*) from tActivity ca (nolock) where ca.ContactKey = a.ContactKey and ca.ParentActivityKey = 0) as ContactCount,
	(select count(*) from tActivity cpa (nolock) where cpa.ContactCompanyKey = a.ContactCompanyKey and cpa.ParentActivityKey = 0) as CompanyCount,
	(select count(*) from tActivity opa (nolock) where opa.LeadKey = a.LeadKey and opa.ParentActivityKey = 0) as OpportunityCount,
	(select count(*) from tActivity pja (nolock) where pja.ProjectKey = a.ProjectKey and pja.ParentActivityKey = 0) as ProjectCount,
	p.ProjectNumber,
	p.ProjectName,
	
	t.TaskID,
	t.TaskName,
	
	--p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
	--u.FirstName + ' ' + u.LastName as AssignedToName,
	--orig.FirstName + ' ' + orig.LastName as OriginatorName,
	ab.FirstName + ' ' + ab.LastName as AddedBy,
	ub.FirstName + ' ' + ub.LastName as UpdatedBy,
	u.FirstName + ' ' + u.LastName as AssignedUserName,
	u.TimeZoneIndex, --Assigned user's TimeZoneIndex
	orig.FirstName + ' ' + orig.LastName as OriginatorUserName,
	glc.GLCompanyID,
	glc.GLCompanyName
from tActivity a (nolock)
	left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
	left outer join tUser con (nolock) on a.ContactKey = con.UserKey
	left outer join tLead l (nolock) on a.LeadKey = l.LeadKey
	left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
	left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	left outer join tUser orig (nolock) on a.OriginatorUserKey = orig.UserKey
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
	left outer join tUser ab (nolock) on a.AddedByKey = ab.UserKey
	left outer join tUser ub (nolock) on a.UpdatedByKey = ub.UserKey
	left outer join tGLCompany glc (nolock) on a.GLCompanyKey = glc.GLCompanyKey
Where a.ActivityKey = @ActivityKey

-- Email List
IF @ParentActivityKey = 0
BEGIN
	Select u.UserKey, 0 as UserLeadKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
		, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex, 1 as Editable
		from tActivityEmail ae (nolock)
		inner join tUser u (nolock) on ae.UserKey = u.UserKey
		Where ActivityKey = @ActivityKey
	union
	select 0 as UserKey, u.UserLeadKey, rtrim(ltrim(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
		, isnull(u.Email, '') as Email, 0, TimeZoneIndex, 1 as Editable
		from tActivityEmail ae (nolock)
		inner join tUserLead u (nolock) on ae.UserLeadKey = u.UserLeadKey
		where ActivityKey = @ActivityKey
END
ELSE
BEGIN
	Select u.UserKey, 0 as UserLeadKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
		, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex, 0 as Editable
		from tActivityEmail ae (nolock)
		inner join tUser u (nolock) on ae.UserKey = u.UserKey
		Where ActivityKey = @ActivityKey
	union
	select 0 as UserKey, u.UserLeadKey, rtrim(ltrim(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
		, isnull(u.Email, '') as Email, 0, TimeZoneIndex, 0 as Editable
		from tActivityEmail ae (nolock)
		inner join tUserLead u (nolock) on ae.UserLeadKey = u.UserLeadKey
		where ActivityKey = @ActivityKey

END

-- Attachments
Select *
From tAttachment (nolock)
Where
 AssociatedEntity = 'tActivity' AND EntityKey = @ActivityKey
Order By FileName

-- Several selects for each type of link, joined on the client
	
Select 'Project' as Type, 
	'tProject' as Entity,
	p.ProjectKey as EntityKey,
	p.ProjectNumber + ' ' + p.ProjectName as LinkDescription
from tActivityLink al (nolock) 
	inner join tProject p (nolock) on al.EntityKey = p.ProjectKey
Where ActivityKey = @ActivityKey and Entity = 'tProject'

Select 'Contact' as Type, 
	'tUser' as Entity,
	u.UserKey as EntityKey,
	LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))) as LinkDescription,
	u.Email,
	u.Phone1,
	u.Cell
from tActivityLink al (nolock) 
	inner join tUser u (nolock) on al.EntityKey = u.UserKey
Where ActivityKey = @ActivityKey and Entity = 'tUser'

Select 'Lead' as Type, 
	'tUserLead' as Entity,
	u.UserLeadKey as EntityKey,
	LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))) as LinkDescription,
	u.Email,
	u.Phone1,
	u.Phone2
from tActivityLink al (nolock) 
	inner join tUserLead u (nolock) on al.EntityKey = u.UserLeadKey
Where ActivityKey = @ActivityKey and Entity = 'tUserLead'

Select 'Company' as Type, 
	'tCompany' as Entity,
	u.CompanyKey as EntityKey,
	u.CompanyName as LinkDescription
from tActivityLink al (nolock) 
	inner join tCompany u (nolock) on al.EntityKey = u.CompanyKey
Where ActivityKey = @ActivityKey and Entity = 'tCompany'

Select 'Opportunity' as Type, 
	'tLead' as Entity,
	u.LeadKey as EntityKey,
	u.Subject as LinkDescription
from tActivityLink al (nolock) 
	inner join tLead u (nolock) on al.EntityKey = u.LeadKey
Where ActivityKey = @ActivityKey and Entity = 'tLead'

Select 'Task' as Type, 
	'tTask' as Entity,
	t.TaskKey as EntityKey,
	case when t.TaskID is null then p.ProjectNumber + ' - ' + t.TaskName else p.ProjectNumber + ' - ' + t.TaskID + ' - ' + t.TaskName end as LinkDescription
	from tActivityLink al (nolock) 
	inner join tTask t (nolock) on al.EntityKey = t.TaskKey
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where ActivityKey = @ActivityKey and Entity = 'tTask'

SELECT	'Project File' as Type,
		'tDAFile' as Entity,
		f.FileKey as EntityKey,
		f.FileName as LinkDescription
FROM	tActivityLink al (nolock)
INNER JOIN tDAFile f ON al.EntityKey = f.FileKey
WHERE	al.ActivityKey = @ActivityKey
AND		al.Entity = 'tDAFile'

SELECT	'Campaign' as Type, 
		'tCampaign' as Entity,
		c.CampaignKey as EntityKey,
		ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') as LinkDescription
FROM	tActivityLink al (nolock) 
INNER JOIN tCampaign c (nolock) on al.EntityKey = c.CampaignKey AND al.Entity = 'tCampaign'
WHERE	al.ActivityKey = @ActivityKey

SELECT	'Campaign Segment' as Type, 
		'tCampaignSegment' as Entity,
		cs.CampaignSegmentKey as EntityKey,
		ISNULL(cs.SegmentName, '') + ' (' + ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') + ')' as LinkDescription,
		cs.CampaignKey
FROM	tActivityLink al (nolock) 
INNER JOIN tCampaignSegment cs (nolock) ON al.EntityKey = cs.CampaignSegmentKey AND al.Entity = 'tCampaignSegment'
INNER JOIN tCampaign c (nolock) ON cs.CampaignKey = c.CampaignKey
WHERE	al.ActivityKey = @ActivityKey
GO
