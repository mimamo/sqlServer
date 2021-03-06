USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10500tActivity]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10500tActivity]

AS

/*
|| When      Who Rel      What
|| 7/2/09    CRG 10.5.0.0 Removed TimeZoneIndex
|| 8/14/09   GHL 10.5.0.7 (60475) tNote records for Entity = 'Company'
||                        have EntityKey = CompanyKey, not UserKey ... 
||                        So comment out the join with UserKey
||                        And expand to n.Entity in ( 'Contact', 'Company')
||                        for the join with CompanyKey
*/

	if exists(select 1 from tActivity)
		return


	-- Contact Notes have entity Company (why not sure) and a join to tUser
	/* GHL commented this out
		INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		OldNoteKey,
		OldParentNoteKey,
		Private,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		UserLeadKey,
		LeadKey,
		ProjectKey,
		StandardActivityKey,
		AssignedUserKey,
		OriginatorUserKey,
		CustomFieldKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		ActivityTime,
		Completed,
		DateCompleted,
		Notes,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated
		)
		
		Select 
		CompanyKey, --CompanyKey,
		0, --ParentActivityKey,
		0, --RootActivityKey,
		-1, -- Old Note Key
		0, -- Old Parent Note key
		0, --Private,
		NULL, --Type,
		NULL, --Priority,
		Subject, --Subject,
		NULL, --ContactCompanyKey,
		EntityKey, --ContactKey,
		NULL, --UserLeadKey,
		NULL, --LeadKey,
		NULL, --ProjectKey,
		NULL, --StandardActivityKey,
		CreatedBy, --AssignedUserKey,
		CreatedBy, --OriginatorUserKey,
		NULL, --CustomFieldKey,
		0, --VisibleToClient,
		NULL, --Outcome,
		DateCreated, --ActivityDate,
		NULL, --StartTime,
		NULL, --EndTime,
		0, --ReminderMinutes,
		NULL, --ActivityTime,
		1, --Completed,
		DateCreated, --DateCompleted,
		NoteField, --Notes,
		CreatedBy, --AddedByKey,
		CreatedBy, --UpdatedByKey,
		DateCreated, --DateAdded,
		DateCreated --DateUpdated
		From tNote n 
		inner join tUser u on n.EntityKey = u.UserKey
		Where n.Entity = 'Company'
	*/	




	-- Company Notes have entity Contact (why not sure) 
		INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		OldNoteKey,
		OldParentNoteKey,
		Private,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		UserLeadKey,
		LeadKey,
		ProjectKey,
		StandardActivityKey,
		AssignedUserKey,
		OriginatorUserKey,
		CustomFieldKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		ActivityTime,
		Completed,
		DateCompleted,
		Notes,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated
		)
		
		Select 
		ng.CompanyKey, --CompanyKey,
		0, --ParentActivityKey,
		0, --RootActivityKey,
		-2, -- Old Note Key
		0, -- Old Parent Note key
		0, --Private,
		NULL, --Type,
		NULL, --Priority,
		ISNULL(ng.GroupName, n.Subject), --Subject,
		n.EntityKey, --ContactCompanyKey,
		NULL, --ContactKey,
		NULL, --UserLeadKey,
		NULL, --LeadKey,
		NULL, --ProjectKey,
		NULL, --StandardActivityKey,
		n.CreatedBy, --AssignedUserKey,
		n.CreatedBy, --OriginatorUserKey,
		NULL, --CustomFieldKey,
		0, --VisibleToClient,
		NULL, --Outcome,
		n.DateCreated, --ActivityDate,
		NULL, --StartTime,
		NULL, --EndTime,
		0, --ReminderMinutes,
		NULL, --ActivityTime,
		1, --Completed,
		n.DateCreated, --DateCompleted,
		Case When ng.GroupName is null then n.NoteField else n.Subject + Cast(CHAR(13) + CHAR(10) as varchar) + Cast(n.NoteField as varchar(8000)) end, --Notes,
		n.CreatedBy, --AddedByKey,
		n.CreatedBy, --UpdatedByKey,
		n.DateCreated, --DateAdded,
		n.DateCreated --DateUpdated
		From tNote n 
		inner join tNoteGroup ng on n.NoteGroupKey = ng.NoteGroupKey
		--Where n.Entity = 'Contact'
		Where n.Entity in ( 'Contact', 'Company')
		


-- Contact Activities

	INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		Private,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		UserLeadKey,
		LeadKey,
		ProjectKey,
		StandardActivityKey,
		AssignedUserKey,
		OriginatorUserKey,
		CustomFieldKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		ActivityTime,
		Completed,
		DateCompleted,
		Notes,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated
		)
	Select
		CompanyKey,
		0, -- parent key
		0, -- root key
		0,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		NULL,
		LeadKey,
		ProjectKey,
		NULL,
		AssignedUserKey,
		AssignedUserKey, --originator
		NULL, -- custom field key
		0,  -- visible to client
		Outcome,
		ActivityDate,
		NULL, --start time
		NULL, -- end time
		0, -- reminder min
		ActivityTime,
		CASE When Status = 2 then 1 Else 0 End,
		Case When Status = 2 then DateUpdated else NULL end,
		Notes,
		AssignedUserKey,
		AssignedUserKey,
		DateAdded,
		DateUpdated
	From tContactActivity
	
	
	Update tActivity Set RootActivityKey = ActivityKey
	
	
	
	-- Project Notes
		INSERT tActivity
		(
		CompanyKey,
		ParentActivityKey,
		RootActivityKey,
		OldNoteKey,
		OldParentNoteKey,
		Private,
		Type,
		Priority,
		Subject,
		ContactCompanyKey,
		ContactKey,
		UserLeadKey,
		LeadKey,
		ProjectKey,
		StandardActivityKey,
		AssignedUserKey,
		OriginatorUserKey,
		CustomFieldKey,
		VisibleToClient,
		Outcome,
		ActivityDate,
		StartTime,
		EndTime,
		ReminderMinutes,
		ActivityTime,
		Completed,
		DateCompleted,
		Notes,
		AddedByKey,
		UpdatedByKey,
		DateAdded,
		DateUpdated
		)
		
		Select 
		CompanyKey, --CompanyKey,
		0, --ParentActivityKey,
		0, --RootActivityKey,
		ProjectNoteKey,
		ParentNoteKey,
		0, --Private,
		NULL, --Type,
		NULL, --Priority,
		LEFT(Cast(ISNULL(Note, '') as Varchar), 100), --Subject,
		NULL, --ContactCompanyKey,
		NULL, --ContactKey,
		NULL, --UserLeadKey,
		NULL, --LeadKey,
		ProjectKey, --ProjectKey,
		NULL, --StandardActivityKey,
		AddedByKey, --AssignedUserKey,
		AddedByKey, --OriginatorUserKey,
		NULL, --CustomFieldKey,
		VisibleToClient, --VisibleToClient,
		NULL, --Outcome,
		DateAdded, --ActivityDate,
		NULL, --StartTime,
		NULL, --EndTime,
		0, --ReminderMinutes,
		NULL, --ActivityTime,
		1, --Completed,
		DateAdded, --DateCompleted,
		Note, --Notes,
		AddedByKey, --AddedByKey,
		AddedByKey, --UpdatedByKey,
		DateAdded, --DateAdded,
		DateUpdated --DateUpdated
		From tProjectNote
		
	Insert tActivityLink(ActivityKey, Entity, EntityKey)
	Select Distinct
		a.ActivityKey, 'tUser', pl.EntityKey
	From
		tActivity a (nolock) 
		inner join tProjectNoteLink pl (nolock) on a.OldNoteKey = pl.ProjectNoteKey
		
	Insert tActivityEmail(ActivityKey, UserKey)
	Select Distinct
		a.ActivityKey, pl.UserKey
	From
		tActivity a (nolock) 
		inner join tProjectNoteUser pl (nolock) on a.OldNoteKey = pl.ProjectNoteKey

	
	UPDATE tActivity
	SET ParentActivityKey = tActivity_1.ActivityKey
	FROM tActivity 
	INNER JOIN tActivity AS tActivity_1 ON tActivity.OldNoteKey = tActivity_1.OldParentNoteKey
	
	-- pass to set the root activitykey
	
	-- if you do not have a parent, then you must be a root
	Update tActivity Set RootActivityKey = ActivityKey Where ParentActivityKey = 0
	
	/*
	Cant do it this way as recursiveness is too high
	declare @key int
	declare @retVal int
	select @key = -1
	while 1=1
	BEGIN
		select @key = min(ActivityKey) from tActivity Where ParentActivityKey > 0 and RootActivityKey = 0 and ActivityKey > @key
			if @key is null
				break
				
			exec spConverttActivityParents @key, 0
		
		
	END
	*/
	
	
	-- Convert Message attachments
	-- old entity ProjectNote  new tActivity
	
	if not exists (select 1 from sysobjects 
		where xtype='U' 
		and name = 'tmpAttachment')
	select * Into tmpAttachment from tAttachment 
	
	Update tAttachment Set AssociatedEntity = 'tActivity', EntityKey = ActivityKey
	from 
		tAttachment 
		inner join tActivity on tAttachment.EntityKey = tActivity.OldNoteKey and tAttachment.AssociatedEntity = 'ProjectNote'
		
		
	
	-- add in all the email to's for the sub children (need to test)
	Insert tActivityEmail(ActivityKey, UserKey)
	Select Distinct a.ActivityKey, root.UserKey
	From tActivity a 
	inner join (
	select a.ActivityKey, UserKey, RootActivityKey
	from tActivityEmail ae
	inner join tActivity a on a.ActivityKey = ae.ActivityKey) as root on a.RootActivityKey = root.ActivityKey
	Where a.ActivityKey <> a.RootActivityKey
	
	Insert tActivityLink(ActivityKey, Entity, EntityKey)
	Select ActivityKey, 'tProject', ProjectKey
	From tActivity Where ProjectKey > 0	
		
	Insert tActivityLink(ActivityKey, Entity, EntityKey)
	Select ActivityKey, 'tCompany', ContactCompanyKey
	From tActivity Where ContactCompanyKey > 0	
	
	Insert tActivityLink(ActivityKey, Entity, EntityKey)
	Select ActivityKey, 'tUser', ContactKey
	From tActivity Where ContactKey > 0	
	
	Insert tActivityLink(ActivityKey, Entity, EntityKey)
	Select ActivityKey, 'tLead', LeadKey
	From tActivity Where LeadKey > 0
GO
