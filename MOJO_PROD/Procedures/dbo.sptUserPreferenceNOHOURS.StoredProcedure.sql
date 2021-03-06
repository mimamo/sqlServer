USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceNOHOURS]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceNOHOURS]

	@WorkDate smalldatetime,
	@Value int,
	@UserKey int

AS --Encrypt
  /*
  || When     Who Rel       What
  || 07/23/09 GWG 10.505	Modified the where clause so that client vendor logins cant be picked
  || 07/28/09 GWG 10.505    Rolled back last change
  */
  
-- Mode
-- 1 = All People in the company
-- 2 = All People they approve time for
-- 3 = All people I supervise

Declare @CompanyKey int
		,@Supervisor tinyint
		,@MyDepartmentKey int
		
Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
	  ,@Supervisor = ISNULL(Supervisor, 0) 
	  ,@MyDepartmentKey = ISNULL(DepartmentKey, 0)
from tUser (nolock)
Where UserKey = @UserKey

if @Value = 1
	Select
		up.*,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
		ISNULL((Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate), 0) as ActualHours
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where
		up.TimesheetRequired = 1 and
		u.Active = 1 and
		c.Locked = 0 And
		(u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey)

if @Value = 2
	Select
		up.*,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
		ISNULL((Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate), 0) as ActualHours
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where
		up.TimesheetRequired = 1 and
		u.Active = 1 and
		c.Locked = 0 And
		u.TimeApprover = @UserKey


if @Value = 3
Begin

	If @MyDepartmentKey = 0
		-- If I do not have a department, send for everyone in my company who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
			ISNULL((Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate), 0) as ActualHours
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
			inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where	up.TimesheetRequired = 1
		And		(u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey)
		And		u.Active = 1 
		And		c.Locked = 0
		And		isnull(u.Supervisor, 0) = 0
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor
		
	Else
		-- If I have a department, send for everyone in my department who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
			ISNULL((Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate), 0) as ActualHours
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
			inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where	up.TimesheetRequired = 1 
		And		isnull(u.DepartmentKey, 0) = @MyDepartmentKey
		And		u.Active = 1 
		And		isnull(u.Supervisor, 0) = 0 
		And		c.Locked = 0
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor
		
					
End
GO
