USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficStaffScheduleGetUserCalendars]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficStaffScheduleGetUserCalendars]
	@CompanyKey int,
	@OfficeKey int = NULL,
	@ServiceKey int = NULL,
	@SkillKey int = NULL,
	@UserKey int = NULL
AS 

  /*
  || When     Who Rel       What
  || 1/10/13  CRG 10.5.6.3	Created to get the users for the Staff Schedule block out calendars. This user criteria logic is a copy from spTrafficStaffScheduleGetCalendarEvents
  || 1/19/15  WDF 10.5.8.8	Added code to allow Contacts to be pulled in as well
  */
  
	/* Assume created in VB
	create table #departmentKeys (DepartmentKey int null)
	create table #teamKeys (TeamKey int null)
	*/

	DECLARE @AllDepartments int, @AllTeams int
	
	if (Select  count(*) from #departmentKeys) = 0
		Select @AllDepartments = 0
	else
		Select @AllDepartments = 1
		
	if (Select  count(*) from #teamKeys) = 0
		Select @AllTeams = 0
	else
		Select @AllTeams = 1  

	SELECT u.UserKey
	FROM   tUser u (nolock)
	WHERE  ((u.CompanyKey = @CompanyKey)
	   OR   (u.OwnerCompanyKey = @CompanyKey and u.ClientVendorLogin = 0))
	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	AND   (@AllDepartments = 0 or ISNULL(u.DepartmentKey, 0) in (Select DepartmentKey from #departmentKeys))
	--AND   @ProjectStatusKey 
	AND	  (@ServiceKey IS NULL OR @ServiceKey IN 
				(SELECT us.ServiceKey FROM tUserService us (NOLOCK)
				WHERE us.UserKey = u.UserKey))
	AND	  (@SkillKey IS NULL OR @SkillKey IN 
				(SELECT us2.SkillKey FROM tUserSkill us2 (NOLOCK)
				WHERE us2.UserKey = u.UserKey))
	AND    u.Active = 1
	AND   (@UserKey IS NULL OR u.UserKey = @UserKey)
	AND   (@AllTeams = 0 or u.UserKey in (Select UserKey from tTeamUser (nolock) inner join #teamKeys on tTeamUser.TeamKey = #teamKeys.TeamKey))
GO
