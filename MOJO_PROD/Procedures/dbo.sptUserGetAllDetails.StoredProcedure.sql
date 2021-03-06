USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetAllDetails]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetAllDetails]
(
  @UserKey int
 ,@AllDetails int = 1
 ,@OwnerUserKey int = -1
 )

AS --Encrypt

  /*
  || When     Who Rel      What
  || 05/22/09 GHL 10.5     Added AllDetails to get basic info 
  || 08/05/09 RLB 10.506   (58891)An issue on app where there was data for UserKey = 0 in some tables
  || 08/28/09 MFT 10.508   Added @IsContact logic to filter out some data tables for employee records
  || 9/10/09  CRG 10.5.1.0 Added Default Calendar query
  || 9/11/09  CRG 10.5.1.0 Added call to SP to ensure that existing employees have a default calendar when they're pulled up
  || 12/11/09 GWG 10.5.1.4 Added in the joins for the lookups 
  || 03/02/11 GHL 10.5.4.2 Added FolderName for mobile contact screen
  || 05/25/11 QMD 10.5.4.4 (112424) Added the join to tSyncFolder to get sync direction and google folder name 
  || 07/27/11 QMD 10.5.4.6 (117171) Added the join to tSyncFolder to get sync direction for exchange 
  || 03/20/12 GWG 10.5.5.4 Added GL Company Access list.
  || 06/13/12 GHL 10.5.5.7 Added another GL Company Access list
  || 08/20/13 MFT 10.5.7.1 Added CreditCardApproverName (and tUser join) to support lookup
  || 04/23/14 QMD 10.5.7.9 Added UserToken
  || 06/19/14 MFT 10.5.8.1 Added join for ReportsTo
  || 07/03/14 MFT 10.5.8.1 Added tSocialMedia
  || 07/22/14 MFT 10.5.8.2 Added tAppFavorite join
  || 09/18/14 MFT 10.5.8.4 Added extra @AllDetails values to further limit return
  || 10/13/14 WDF 10.5.8.5 Added TitleName and TitleID
  || 10/27/14 RLB 10.5.8.5 Added ContactOwnerName
  || 10/28/14 RLB 10.5.8.5 Added TimeZoneDescription and added glcompany name and id on the restrict
  || 11/03/14 MFT 10.5.8.6 Removed tSocialMedia
  || 12/04/14 QMD 10.5.8.6 UserToken changed to PublicUserToken
  || 12/05/14 MFT 10.5.8.6 Added ContactFullName
  || 12/18/14 RLB 10.5.8.7 Pulling New Goal Table data
  || 03/04/15 RLB 10.5.9.0 Added CompanyOwnerKey and FolderUserKey for rights check
 */

Declare @MinActivityDate smalldatetime, @CompanyKey int, @ClientProductKey int, @ClientDivisionKey int, @ReportsToKey int, @IsContact bit

SELECT @IsContact = 0
Select @IsContact = CASE WHEN ISNULL(OwnerCompanyKey, 0) > 0 THEN 1 ELSE 0 END, @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @ClientProductKey = ClientProductKey, @ClientDivisionKey = ClientDivisionKey, @ReportsToKey = ReportsToKey from tUser (nolock) Where UserKey = @UserKey and @UserKey > 0 

-- If it's an existing employee, make sure they have a default calendar
IF @IsContact = 0 AND @UserKey > 0
	EXEC spCalendarManagerEnsureUserDefaultCalendar @UserKey

IF @AllDetails IN (0, 1, 9)
	Select u.*
		,CASE
			WHEN LEN(ISNULL(u.FirstName, '') + ISNULL(u.LastName, '')) > 0 THEN
				ISNULL(u.FirstName, '') + CASE WHEN LEN(ISNULL(u.FirstName, '')) > 0 THEN ' ' ELSE '' END + ISNULL(u.LastName, '')
			ELSE ISNULL(u.UserCompanyName, ISNULL(c.CompanyName, ''))
			END AS ContactFullName
		,c.CompanyName as LinkedCompanyName
		,ISNULL(c.ContactOwnerKey, 0) as CompanyOwnerKey
		,c.DefaultAddressKey
		,cb.FirstName + ' ' + cb.LastName as CreatedByName
		,mb.FirstName + ' ' + mb.LastName as ModifiedByName
		,ca.FirstName + ' ' + ca.LastName as CreditCardApproverName
		,rt.FirstName + ' ' + rt.LastName as ReportsToName
		,co.FirstName + ' ' + co.LastName as ContactOwnerName
		,up.EmailMailBox
		,up.EmailUserID
		,up.EmailPassword
		,up.PublicUserToken
		,v.VendorID
		,v.CompanyName
		,cl.ClassID
		,cl.ClassName
		,o.OfficeName
		,d.DepartmentName
		,gl.GLCompanyID
		,gl.GLCompanyName
		,t.TitleName
		,t.TitleID
		,cf.FolderName
		,cf.UserKey as FolderUserKey
		,'' as TimeZoneDescription
		,CASE WHEN ISNULL(af.AppFavoriteKey, 0) > 0 THEN 1 ELSE 0 END AS IsFavorite
	from tUser u (nolock) 
	left outer join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	left outer join tUser cb (nolock) on u.AddedByKey = cb.UserKey
	left outer join tUser mb (nolock) on u.UpdatedByKey = mb.UserKey
	left outer join tUser co (nolock) on u.OwnerKey = co.UserKey
	left outer join tUser ca (nolock) on u.CreditCardApprover = ca.UserKey
	left outer join tUser rt (nolock) on u.ReportsToKey = rt.UserKey
	left outer join tTitle t (nolock) ON u.TitleKey = t.TitleKey
	left outer join tUserPreference up (nolock) on u.UserKey = up.UserKey
	left outer join tGLCompany gl (nolock) on u.GLCompanyKey = gl.GLCompanyKey
	left outer join tCompany v (nolock) on u.VendorKey = v.CompanyKey
	left outer join tClass cl (nolock) on u.ClassKey = cl.ClassKey
	left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
	left outer join tCMFolder cf (nolock) on u.CMFolderKey = cf.CMFolderKey
	LEFT JOIN tAppFavorite af (nolock) ON u.UserKey = af.ActionKey AND af.ActionID = 'cm.contacts' AND af.UserKey = @OwnerUserKey
	Where u.UserKey = @UserKey and @UserKey > 0

-- no need to stress the database if all details are not required
IF @AllDetails = 0
	RETURN 1

-- last activity
IF @IsContact = 1 AND @AllDetails IN (1, 2)
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUser cont (nolock) on cont.LastActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserKey = @UserKey and @UserKey > 0

-- next activity
IF @IsContact = 1 AND @AllDetails IN (1, 2)
	Select a.*, u.FirstName + ' ' + u.LastName as AssignedUserName
		from tActivity a (nolock)
		inner join tUser cont (nolock) on cont.NextActivityKey = a.ActivityKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	Where 
		cont.UserKey = @UserKey and @UserKey > 0
	
-- Skills
IF @AllDetails IN (1, 3)
	Select * from tUserSkill (nolock) Where UserKey = @UserKey and @UserKey > 0

-- Specialties
IF @AllDetails IN (1, 4)
	Select * from tUserSkillSpecialty (nolock) Where UserKey = @UserKey and @UserKey > 0

-- Notifications
IF @AllDetails IN (1, 5)
	Select * from tUserNotification (nolock) Where UserKey = @UserKey and @UserKey > 0 

-- Preferences
IF @AllDetails IN (1, 6)
	Select * from tUserPreference (nolock) Where UserKey = @UserKey and @UserKey > 0

-- Services
IF @AllDetails IN (1, 7)
	Select * from tUserService (nolock) Where UserKey = @UserKey and @UserKey > 0

-- MarketingLists
IF @IsContact = 1 AND @AllDetails IN (1, 8)
	Select * from tMarketingListList (nolock) Where Entity = 'tUser' and EntityKey = @UserKey and @UserKey > 0

-- Address List
IF @AllDetails IN (1, 9)
	Select *, 'Personal' as AddressType from tAddress (nolock)
	Where Entity = 'tUser' and EntityKey = @UserKey and @UserKey > 0
	Order By AddressName

-- level history
IF @IsContact = 1 AND @AllDetails IN (1, 10)
	SELECT *
	FROM   tLevelHistory lh (NOLOCK)
	WHERE  EntityKey = @UserKey and Entity = 'tUser' and @UserKey > 0
	Order By LevelDate DESC
	
-- Default Calendar
IF @IsContact = 0 AND @AllDetails IN (1, 11)
	SELECT	f.*, u.DefaultCalendarColor, u.UserID, 1 AS IsDefault, 1 AS IncludeInSync, sf.SyncDirection, s.SyncDirection AS GoogleSyncDirection, 
	s.SyncFolderName AS GoogleSyncFolderName
	FROM	tCMFolder f (nolock)
	INNER JOIN tUser u (nolock) ON f.CMFolderKey = u.DefaultCMFolderKey
	LEFT JOIN tSyncFolder sf (nolock) ON sf.SyncFolderKey = f.SyncFolderKey
	LEFT JOIN tSyncFolder s (nolock) ON f.GoogleSyncFolderKey = s.SyncFolderKey 
	WHERE	u.UserKey = @UserKey and @UserKey > 0
	
	-- add in a restriction layer if the person is not allowed to access a particular company
IF @AllDetails IN (1, 12)
	select glc.GLCompanyKey, glc.GLCompanyID, glc.GLCompanyName, 
		(Select 1 from tUserGLCompanyAccess glca (nolock) Where glca.GLCompanyKey = glc.GLCompanyKey and glca.UserKey = @UserKey) as Selected
	from tGLCompany glc (nolock) 
	Where glc.CompanyKey = @CompanyKey and glc.Active = 1
	order by glc.GLCompanyID, glc.GLCompanyName

	-- Access restriction
IF @AllDetails IN (1, 13)
	SELECT glca.*, glc.GLCompanyID, glc.GLCompanyName
	FROM   tGLCompanyAccess glca (nolock)
		inner join tGLCompany glc (nolock) on glca.GLCompanyKey = glc.GLCompanyKey
	WHERE  glca.CompanyKey = @CompanyKey
	AND    glca.Entity = 'tUser'
	AND    glca.EntityKey = @UserKey
	order by glc.GLCompanyName

	-- get Goal data
IF @AllDetails IN (1, 14)
	SELECT *
	FROM   tGoal gl (nolock)
	WHERE gl.Entity = 'tUser'
	AND    gl.EntityKey = @UserKey
	order by gl.Year
GO
