USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceGetApprovedTimes]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceGetApprovedTimes]
	@Value int,
	@UserKey int
	

AS --Encrypt

/*
|| When      Who Rel      What
|| 10/15/08  CRG 10.0.1.1 Limiting timesheets to ones with EndDates less than 40 days old
|| 06/04/12  GHL 10.556   Added logic for GL Company restrict
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
		u.Email,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
		ts.StartDate,
		ts.EndDate,
		ts.Status,
		ts.ApprovalComments
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		Inner Join tTimeSheet ts (nolock) on u.UserKey = ts.UserKey
	Where up.TimesheetRequired = 1
	and   u.Active = 1 
	and	 (u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey) 
	and (@RestrictToGLCompany = 0 OR 
	    u.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)
	and	 ts.Status in (2, 4)
	and DATEDIFF(day, ts.EndDate, GETDATE()) <= 40
	Order By u.LastName

if @Value = 2
	Select
		up.*,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email,
		ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
		ts.StartDate,
		ts.EndDate,
		ts.Status,
		ts.ApprovalComments
	From
		tUserPreference up (nolock)
		Inner Join tUser u (nolock) on up.UserKey = u.UserKey
		Inner Join tTimeSheet ts (nolock) on u.UserKey = ts.UserKey
	Where
		up.TimesheetRequired = 1 and
		u.TimeApprover = @UserKey and
		u.Active = 1 and
		ts.Status in (2, 4)
	AND DATEDIFF(day, ts.EndDate, GETDATE()) <= 40
	Order By u.LastName


if @Value = 3 
BEGIN
	If @MyDepartmentKey = 0
		-- If I do not have a department, send for everyone in my company who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
			ts.StartDate,
			ts.EndDate,
			ts.Status,
			ts.ApprovalComments
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
			Inner Join tTimeSheet ts (nolock) on u.UserKey = ts.UserKey
		Where	up.TimesheetRequired = 1
		And		u.Active = 1 		
		And		(u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey)
		And		isnull(u.Supervisor, 0) = 0
		And		ts.Status in (2, 4)		
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor
		AND		DATEDIFF(day, ts.EndDate, GETDATE()) <= 40
		Order By u.LastName

	Else

		-- If I do have a department, send for everyone in my department who is not a supervisor
		Select
			up.*,
			u.FirstName + ' ' + u.LastName as UserName,
			u.Email,
			ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
			ts.StartDate,
			ts.EndDate,
			ts.Status,
			ts.ApprovalComments
		From
			tUserPreference up (nolock)
			Inner Join tUser u (nolock) on up.UserKey = u.UserKey
			Inner Join tTimeSheet ts (nolock) on u.UserKey = ts.UserKey
		Where	up.TimesheetRequired = 1
		And		u.Active = 1 
		And		isnull(u.DepartmentKey, 0) = @MyDepartmentKey
		And		isnull(u.Supervisor, 0) = 0
		And		ts.Status in (2, 4)		
		And		@Supervisor = 1 -- Do not send if I am not a Supervisor
		AND		DATEDIFF(day, ts.EndDate, GETDATE()) <= 40
		Order By u.LastName
END
GO
