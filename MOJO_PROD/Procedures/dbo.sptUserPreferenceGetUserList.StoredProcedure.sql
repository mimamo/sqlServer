USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceGetUserList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceGetUserList]
	@Value int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel     What
  || 07/23/09 GWG 10.505	Modified the where clause so that client vendor logins cant be picked
  || 07/28/09 GWG 10.505  Rolled back last change
  || 06/04/12 GHL 10.556  Added logic for GL Company restrict
  || 10/29/12 MFT 10.561  (158216) Changed u.DateAdded to ISNULL(u.DateHired, u.DateAdded)
  || 02/28/13 KMC 10.565  (169856) Added the ISNULL(u.ClientVendorLogin, 0) = 0 to the WHERE clause
  */
  
-- Mode
-- 1 = All People in the company
-- 2 = All People they approve time for
-- 3 = All people I supervise

Declare @CompanyKey int
		,@Supervisor tinyint
		,@MyDepartmentKey int
		,@RestrictToGLCompany int

Select @CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	  ,@Supervisor = ISNULL(u.Supervisor, 0) 
	  ,@MyDepartmentKey = ISNULL(u.DepartmentKey, 0)
	  ,@RestrictToGLCompany = ISNULL(p.RestrictToGLCompany, 0)
from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

if @Value = 1
	Select
		up.*,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email, ISNULL(u.DateHired, u.DateAdded) AS DateAdded,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
	Where up.TimesheetRequired = 1
	and   u.Active = 1 and ISNULL(u.ClientVendorLogin, 0) = 0
	and	(u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey) 
	and (@RestrictToGLCompany = 0 OR 
	    u.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)
	Order By u.LastName

if @Value = 2
	Select
		up.*,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email, ISNULL(u.DateHired, u.DateAdded) AS DateAdded,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
	Where
		up.TimesheetRequired = 1 and
		u.TimeApprover = @UserKey and
		u.Active = 1 and ISNULL(u.ClientVendorLogin, 0) = 0
	Order By u.LastName
	
	
	
if @Value = 3 
Begin

	If @MyDepartmentKey = 0
		-- If I do not have a department, send for everyone in my company who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email, ISNULL(u.DateHired, u.DateAdded) AS DateAdded,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		Where	up.TimesheetRequired = 1 
		And		(u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey) 
		And		u.Active = 1 and ISNULL(u.ClientVendorLogin, 0) = 0 
		And		isnull(u.Supervisor, 0) = 0
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor

		Order By u.LastName
		
	Else
		-- If I have a department, send for everyone in my department who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email, ISNULL(u.DateHired, u.DateAdded) AS DateAdded,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		Where	up.TimesheetRequired = 1 
		And		isnull(u.DepartmentKey, 0) = @MyDepartmentKey
		And		u.Active = 1 and ISNULL(u.ClientVendorLogin, 0) = 0
		And		isnull(u.Supervisor, 0) = 0
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor
		
		Order By u.LastName
	
					
End
GO
