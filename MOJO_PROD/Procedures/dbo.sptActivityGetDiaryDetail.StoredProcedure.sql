USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiaryDetail]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiaryDetail]
	@ActivityKey int
	,@ProjectKey int
	,@UserKey int = null
AS

/*
|| When      Who Rel      What
|| 12/10/10  CRG 10.5.3.9 Created for the To Do screen
|| 12/15/10  GHL 10.5.3.9 Cloned for the Diary screen and added modifications
|| 12/20/10  GHL 10.5.3.9 Taking in account now tAssignment.SubscribeDiary
|| 02/21/11  GHL 10.5.4.1 (104243) include current user in email list when creating a new diary post
|| 03/31/11  GWG 10.5.4.2 Changed the query so clients assigned to the team are in the project team area
|| 04/07/11  GHL 10.5.4.3 (107462) Changed the display of 'email to' users on the Diary screen
||                         First display all project team members (employees or contacts)
||                         Then display Client Contacts (not in the team)
||                         Then display Employees (not in the team)
|| 05/31/11  GHL 10.5.4.5 (112280) Added tActivityLink recs
|| 06/13/11  GHL 10.5.4.5 (114211) Should be able to handle all types of links
|| 06/21/11  RLB 10.5.4.5 (114778) only pulling active users
|| 01/09/12  MFT 10.5.5.2 Added ClientVendorLogin to result sets of "EmailTo list," "Employees," and "Client Contacts"
|| 10/2/12   CRG 10.5.6.0 Added WebDAV files to Link Union
|| 09/30/13  RLB 105.7.3 (187730) added for diary enhancement
|| 03/03/14  GWG 10.5.7.8 If null project is passed in, look it up on the activity
*/

	DECLARE	@CompanyKey int
	
	if @ProjectKey is null
		Select @ProjectKey = ProjectKey from tActivity (nolock) Where ActivityKey = @ActivityKey
			
	SELECT	@CompanyKey = CompanyKey
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	-- Get Activity
	select  a.*
	       ,p.ProjectNumber 
		   ,p.ProjectName 
		   ,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
		   ,p.ClientKey
		   ,p.GLCompanyKey
		   ,p.OfficeKey
		   ,oc.OfficeID
		   ,oc.OfficeName
		   ,t.TaskID 
		   ,t.TaskName
		   ,isnull(t.TaskID + ' - ', '') + t.TaskName as TaskFullName 
		   ,at.TypeName
	from    tActivity a (nolock)
		left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
		left outer join tOffice oc (nolock) on p.OfficeKey = oc.OfficeKey
		left outer join tActivityType at (nolock) on a.ActivityTypeKey = at.ActivityTypeKey
	where   a.ActivityKey = @ActivityKey 

	--Get Attachments
	SELECT	*
	FROM	tAttachment (nolock)
	WHERE	AssociatedEntity = 'tActivity' 
	AND		EntityKey = @ActivityKey
	ORDER BY FileName

	
	-- EmailTo list
	if @ActivityKey > 0
		--Get everyone currently on the email list
		SELECT
			ae.*,
			v.UserName, --Get the user name in case they have been removed from any of the following lists (we'll then list them under the "Other" group).
			ISNULL(v.ClientVendorLogin, 0) AS ClientVendorLogin
		FROM	tActivityEmail ae (nolock)
		INNER JOIN vUserName v (nolock) ON ae.UserKey = v.UserKey
		WHERE	ActivityKey = @ActivityKey
	else
	begin
		--Use defaults on tAssignment
		select v.UserKey, v.UserName
		from   vUserName v (nolock) 
		where  v.UserKey in (select a.UserKey from tAssignment a (nolock)
		                     where a.ProjectKey = @ProjectKey	
							and    isnull(a.SubscribeDiary, 0) = 1
							UNION
							-- but always include the current user in the emails
							-- will be listed under the Other group (if not in Team, Contacts, Employees)
							select @UserKey 
							)
		and v.Active = 1
     
	
	end


	--Next get all employees not in the project team
	SELECT	u.UserKey,
			v.UserName,
			ISNULL(v.ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	tUser u (nolock)
	INNER JOIN vUserName v (nolock) ON u.UserKey = v.UserKey
	--LEFT JOIN tAssignment asn (nolock) ON u.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	WHERE	(
		u.CompanyKey = @CompanyKey
		OR		(u.OwnerCompanyKey = @CompanyKey 
				AND u.ClientVendorLogin = 0 
				AND u.UserID is not null 
				AND u.Password is not null 
				AND u.Active = 1)
		)
	AND u.UserKey not in (select a.UserKey from tAssignment a (nolock)
		                     where a.ProjectKey = @ProjectKey)
	AND v.Active = 1
	ORDER BY v.UserName

	--Next get client contacts (query copied from contact lookup for billing contacts)
	-- Should not be in the team

	DECLARE	@ClientKey int,
			@QueryCompanyKey int

	SELECT	@ClientKey = ClientKey
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	SELECT @QueryCompanyKey = ISNULL(ParentCompanyKey, CompanyKey) FROM tCompany (nolock) WHERE CompanyKey = @ClientKey
		
	SELECT	u.UserKey,
		    v.UserName,
				ISNULL(v.ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	tUser u (nolock)
	INNER JOIN vUserName v (nolock) ON u.UserKey = v.UserKey
	INNER JOIN tCompany c (nolock) ON v.CompanyKey = c.CompanyKey
	--LEFT JOIN tAssignment asn (nolock) ON v.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	WHERE	v.OwnerCompanyKey = @CompanyKey
	AND		v.Active = 1
	AND		(v.CompanyKey = @ClientKey
			OR c.ParentCompany = @QueryCompanyKey
			OR c.CompanyKey = @QueryCompanyKey)
	AND u.UserKey not in (select a.UserKey from tAssignment a (nolock)
		                    where a.ProjectKey = @ProjectKey)
	
	ORDER BY v.UserName
	

	-- Next get team members (Project team)
	-- Will be at the top of the email list 
	-- if you want to include any user (not an employee or company contact), put it in the team first          
	select v.UserKey,
			v.UserName,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
	from   vUserName v (nolock)
		inner join tAssignment a (nolock) on v.UserKey = a.UserKey 
	where a.ProjectKey = @ProjectKey and v.Active = 1
	order by v.UserName

	-- Links
	if @ActivityKey > 0
		
		Select 'Project' as Type, 
			'tProject' as Entity,
			p.ProjectKey as EntityKey,
			p.ProjectNumber + ' ' + p.ProjectName as LinkDescription,
			0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
		from tActivityLink al (nolock) 
			inner join tProject p (nolock) on al.EntityKey = p.ProjectKey
		Where ActivityKey = @ActivityKey and Entity = 'tProject'

		UNION

		Select 'Contact' as Type, 
			'tUser' as Entity,
			u.UserKey as EntityKey,
			LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))) as LinkDescription,
			0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
		from tActivityLink al (nolock) 
			inner join tUser u (nolock) on al.EntityKey = u.UserKey
		Where ActivityKey = @ActivityKey and Entity = 'tUser'

		UNION

		Select 'Lead' as Type, 
			'tUserLead' as Entity,
			u.UserLeadKey as EntityKey,
			LTRIM(RTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))) as LinkDescription,
			0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
		from tActivityLink al (nolock) 
			inner join tUserLead u (nolock) on al.EntityKey = u.UserLeadKey
		Where ActivityKey = @ActivityKey and Entity = 'tUserLead'

		UNION

		Select 'Company' as Type, 
			'tCompany' as Entity,
			u.CompanyKey as EntityKey,
			u.CompanyName as LinkDescription,
			0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
		from tActivityLink al (nolock) 
			inner join tCompany u (nolock) on al.EntityKey = u.CompanyKey
		Where ActivityKey = @ActivityKey and Entity = 'tCompany'

		UNION

		Select 'Opportunity' as Type, 
			'tLead' as Entity,
			u.LeadKey as EntityKey,
			u.Subject as LinkDescription,
			0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
		from tActivityLink al (nolock) 
			inner join tLead u (nolock) on al.EntityKey = u.LeadKey
		Where ActivityKey = @ActivityKey and Entity = 'tLead'

		UNION

		Select 'Task' as Type, 
			'tTask' as Entity,
			t.TaskKey as EntityKey,
			case when t.TaskID is null then p.ProjectNumber + ' - ' + t.TaskName else p.ProjectNumber + ' - ' + t.TaskID + ' - ' + t.TaskName end as LinkDescription
			,0 as CampaignKey,
			NULL as ProjectNumber, --Used for WebDAV
			NULL as ProjectName,
			NULL as ClientID,
			NULL as ClientName,
			NULL as FilesArchived,
			NULL as OfficeKey
			from tActivityLink al (nolock) 
			inner join tTask t (nolock) on al.EntityKey = t.TaskKey
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		Where ActivityKey = @ActivityKey and Entity = 'tTask'

		UNION

		SELECT	'Project File' as Type,
				'tDAFile' as Entity,
				f.FileKey as EntityKey,
				f.FileName as LinkDescription
				,0 as CampaignKey,
				NULL as ProjectNumber, --Used for WebDAV
				NULL as ProjectName,
				NULL as ClientID,
				NULL as ClientName,
				NULL as FilesArchived,
				NULL as OfficeKey
		FROM	tActivityLink al (nolock)
		INNER JOIN tDAFile f ON al.EntityKey = f.FileKey
		WHERE	al.ActivityKey = @ActivityKey
		AND		al.Entity = 'tDAFile'

		UNION

		SELECT	'Campaign' as Type, 
				'tCampaign' as Entity,
				c.CampaignKey as EntityKey,
				ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') as LinkDescription,
				0 as CampaignKey,
				NULL as ProjectNumber, --Used for WebDAV
				NULL as ProjectName,
				NULL as ClientID,
				NULL as ClientName,
				NULL as FilesArchived,
				NULL as OfficeKey
		FROM	tActivityLink al (nolock) 
		INNER JOIN tCampaign c (nolock) on al.EntityKey = c.CampaignKey AND al.Entity = 'tCampaign'
		WHERE	al.ActivityKey = @ActivityKey

		UNION

		SELECT	'Campaign Segment' as Type, 
				'tCampaignSegment' as Entity,
				cs.CampaignSegmentKey as EntityKey,
				ISNULL(cs.SegmentName, '') + ' (' + ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') + ')' as LinkDescription,
				cs.CampaignKey,
				NULL as ProjectNumber, --Used for WebDAV
				NULL as ProjectName,
				NULL as ClientID,
				NULL as ClientName,
				NULL as FilesArchived,
				NULL as OfficeKey
		FROM	tActivityLink al (nolock) 
		INNER JOIN tCampaignSegment cs (nolock) ON al.EntityKey = cs.CampaignSegmentKey AND al.Entity = 'tCampaignSegment'
		INNER JOIN tCampaign c (nolock) ON cs.CampaignKey = c.CampaignKey
		WHERE	al.ActivityKey = @ActivityKey

		UNION

		SELECT	'Project File' as Type,
				al.Entity,
				al.EntityKey,
				al.WebDavPath as LinkDescription,
				0 as CampaignKey,
				p.ProjectNumber, --Used for WebDAV
				p.ProjectName,
				c.CustomerID as ClientID,
				c.CompanyName as ClientName,
				p.FilesArchived,
				p.OfficeKey
		FROM	tActivityLink al (nolock)
		INNER JOIN tProject p (nolock) ON al.EntityKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
		WHERE	al.ActivityKey = @ActivityKey
		AND		al.Entity = 'WebDAVFile'
	else
		select  'Project' as Type
				,'tProject' as Entity
				, ProjectKey as EntityKey
				,ProjectNumber + ' ' + ProjectName as LinkDescription
		from    tProject (nolock) 
		where   ProjectKey = @ProjectKey
GO
