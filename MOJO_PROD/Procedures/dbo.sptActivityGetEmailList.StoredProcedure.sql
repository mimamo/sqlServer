USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetEmailList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetEmailList]
	(
	@ActivityKey int
	,@EmailTo varchar(20) -- Contact, ProjectTeam, ActivityTeam
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 04/14/11 GHL 10.5.4.3 Created to send emails from mobile 
|| 03/09/14 GWG 10.5.7.8 Added sorts by name
*/
	SET NOCOUNT ON

	if UPPER(@EmailTo) = 'ACTIVITYTEAM'  
	Select u.UserKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex
	from tActivityEmail ae (nolock)
	inner join tUser u (nolock) on ae.UserKey = u.UserKey
	Where ActivityKey = @ActivityKey
	Order By u.FirstName, u.LastName

	else if UPPER(@EmailTo) = 'PROJECTTEAM'  
	Select u.UserKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex
	from tActivity a (nolock)
	inner join tAssignment pa (nolock) on a.ProjectKey = pa.ProjectKey
 	inner join tUser u (nolock) on pa.UserKey = u.UserKey
	Where a.ActivityKey = @ActivityKey
	Order By u.FirstName, u.LastName
	
	else if UPPER(@EmailTo) = 'CONTACT'  
	Select u.UserKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex
	from tActivity a (nolock)
	inner join tUser u (nolock) on a.ContactKey = u.UserKey
	Where a.ActivityKey = @ActivityKey
	Order By u.FirstName, u.LastName
	
	RETURN 1
GO
