USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGlobalSearchMobile]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGlobalSearchMobile]
	(
	@CompanyKey int,
	@UserKey int,
	@SearchText varchar(200)
	)

AS

/*
|| When      Who Rel      What
*/

declare @SecurityGroupKey int, @ClientVendorLogin tinyint, @Administrator tinyint

Select @SecurityGroupKey = SecurityGroupKey, @ClientVendorLogin = ISNULL(ClientVendorLogin, 0), @Administrator = ISNULL(Administrator, 0)  from tUser Where UserKey = @UserKey

if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90918 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey)
	SELECT 
		p.ProjectKey,
		p.ProjectNumber + ' - ' + p.ProjectName as label,
		'p' as ent
	From tProject p (nolock)
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND p.Active = 1
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By label
ELSE
	SELECT 
		p.ProjectKey,
		p.ProjectNumber + ' - ' + p.ProjectName as label,
		'p' as ent
	From tProject p (nolock)
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND a.UserKey = @UserKey
		AND p.Active = 1
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By label


if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90918 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey)
	SELECT 
		p.ProjectKey,
		p.ProjectNumber + ' - ' + p.ProjectName as label,
		'ip' as ent
	From tProject p (nolock)
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND p.Active = 0
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By label
ELSE
	SELECT 
		p.ProjectKey,
		p.ProjectNumber + ' - ' + p.ProjectName as label,
		'ip' as ent
	From tProject p (nolock)
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Where
		p.CompanyKey = @CompanyKey
		AND a.UserKey = @UserKey
		AND p.Active = 0
		AND (p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%')
	Order By label


if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 120100 and EntityKey = @SecurityGroupKey)
	SELECT 
		c.CalendarKey,
		Subject as label,
		'm' as ent
	From tCalendar c (nolock) 
	Inner join (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
		Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
		OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tCalendar') as tbl on c.CMFolderKey = tbl.CMFolderKey
	Where CompanyKey = @CompanyKey  and Subject like '%' + @SearchText + '%' 

	UNION
	
	SELECT 
		c.CalendarKey,
		Subject as label,
		'm' as ent
	From tCalendar c (nolock)
	inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 
	Where CompanyKey = @CompanyKey and ca.Entity in ('Organizer', 'Attendee') and ca.EntityKey = @UserKey and Status <> 3 and Subject like '%' + @SearchText + '%' 
	
	Order By label
	
Declare @UseFolder tinyint, @ViewOthers tinyint

if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931600 and EntityKey = @SecurityGroupKey)
BEGIN
	Select @UseFolder = ISNULL(UseContactFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931601 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			UserKey,
			FirstName + ' ' + LastName as label,
			'u' as ent
		From tUser u (nolock) 
		left outer join tCompany c on u.CompanyKey = c.CompanyKey
		Where u.OwnerCompanyKey = @CompanyKey  and (FirstName + ' ' + LastName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
			AND (@ViewOthers = 1 OR OwnerKey = @UserKey)
			AND (u.CMFolderKey is null OR u.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tUser') )
	ELSE
		SELECT 
			UserKey,
			FirstName + ' ' + LastName as label,
			'u' as ent
		From tUser u (nolock) 
		left outer join tCompany c on u.CompanyKey = c.CompanyKey
		Where u.OwnerCompanyKey = @CompanyKey  and (FirstName + ' ' + LastName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
		AND (@ViewOthers = 1 OR OwnerKey = @UserKey)
END



if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931700 and EntityKey = @SecurityGroupKey)
BEGIN
	Select @UseFolder = ISNULL(UseCompanyFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931701 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			CompanyKey,
			CompanyName as label,
			'c' as ent
		From tCompany t (nolock) 
		Where OwnerCompanyKey = @CompanyKey  and CompanyName like '%' + @SearchText + '%'  
			AND (@ViewOthers = 1 OR AccountManagerKey = @UserKey)
			AND (CMFolderKey is null OR CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tCompany') )
	ELSE
		SELECT 
			CompanyKey,
			CompanyName as label,
			'c' as ent
		From tCompany t (nolock) 
		Where OwnerCompanyKey = @CompanyKey  and CompanyName like '%' + @SearchText + '%'
		AND (@ViewOthers = 1 OR AccountManagerKey = @UserKey)
END


if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931100 and EntityKey = @SecurityGroupKey)
BEGIN
	Select @UseFolder = ISNULL(UseOppFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931101 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			LeadKey,
			Subject as label,
			'o' as ent
		From tLead l (nolock) 
		inner join tCompany c on l.ContactCompanyKey = c.CompanyKey
		Where l.CompanyKey = @CompanyKey  and Subject like '%' + @SearchText + '%'  
			AND (@ViewOthers = 1 OR l.AccountManagerKey = @UserKey)
			AND (l.CMFolderKey is null OR l.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tLead') )
	ELSE
		SELECT 
			LeadKey,
			Subject as label,
			'o' as ent
		From tLead l (nolock) 
		inner join tCompany c on l.ContactCompanyKey = c.CompanyKey
		Where l.CompanyKey = @CompanyKey  and Subject like '%' + @SearchText + '%'  
			AND (@ViewOthers = 1 OR l.AccountManagerKey = @UserKey)
END


if (@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 931500 and EntityKey = @SecurityGroupKey)
BEGIN
	Select @UseFolder = ISNULL(UseActivityFolders, 0) from tPreference (nolock) Where CompanyKey = @CompanyKey
	Select @ViewOthers = 1 From tRightAssigned (nolock) Where RightKey = 931501 and EntityKey = @SecurityGroupKey
	if @UseFolder = 1
		SELECT 
			ActivityKey,
			Subject as label,
			'a' as ent
		From tActivity a (nolock) 
			left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) on a.ContactKey = u.UserKey
			left outer join tUser ass (nolock) on a.ContactKey = ass.UserKey
		Where a.CompanyKey = @CompanyKey  and (Subject like '%' + @SearchText + '%' OR Notes like '%' + @SearchText + '%' OR p.ProjectNumber like '%' + @SearchText + '%' )
			AND (@ViewOthers = 1 OR AssignedUserKey = @UserKey or OriginatorUserKey = @UserKey)
			AND (a.CMFolderKey is null OR a.CMFolderKey in (Select Distinct f.CMFolderKey from tCMFolderSecurity fs (nolock) inner join tCMFolder f (nolock) on fs.CMFolderKey = f.CMFolderKey
								Where (fs.Entity = 'tSecurityGroup' and fs.EntityKey = @SecurityGroupKey 
								OR fs.Entity = 'tUser' and EntityKey = @UserKey) and CanView = 1 and f.Entity = 'tActivity') )
	ELSE
		SELECT 
			ActivityKey,
			Subject as label,
			'a' as ent
		From tActivity a (nolock) 
			left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) on a.ContactKey = u.UserKey
			left outer join tUser ass (nolock) on a.ContactKey = ass.UserKey
		Where a.CompanyKey = @CompanyKey  and (Subject like '%' + @SearchText + '%' OR Notes like '%' + @SearchText + '%' OR p.ProjectNumber like '%' + @SearchText + '%' )
			AND (@ViewOthers = 1 OR AssignedUserKey = @UserKey or OriginatorUserKey = @UserKey)
END
GO
