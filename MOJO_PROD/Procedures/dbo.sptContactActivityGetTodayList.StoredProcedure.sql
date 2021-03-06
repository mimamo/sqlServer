USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityGetTodayList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[sptContactActivityGetTodayList]

	(
		@UserKey int,
		@CurDate smalldatetime,
		@IncludeAll tinyint = 0
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/19/08 QMD 10.0  Added additional values for @IncludeAll based on the configuration of the my activities widget
  */


if @IncludeAll = 0 -- CMP85
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.ActivityDate = @CurDate and
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject
	
else if @IncludeAll = 1 -- all
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject

else if @IncludeAll = 2 -- on and before today
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.ActivityDate < DATEADD(dd, 1, @CurDate) and
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject

else if @IncludeAll = 3 -- last 2 weeks
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.ActivityDate > DATEADD(dd, -14, @CurDate) and
		ca.ActivityDate < DATEADD(dd, 1, @CurDate) and
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject


else if @IncludeAll = 4 -- next 2 weeks
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.ActivityDate < DATEADD(dd, 14, @CurDate) and
		ca.ActivityDate > DATEADD(dd, -1, @CurDate)  and
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject
	
else 
	Select
		ca.Subject,
		ca.ContactActivityKey,
		c.CompanyName,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Cell,
		u.Email,
		ca.Notes,
		ca.ActivityDate,
		ca.ActivityTime,
		ca.Priority
	From
		tContactActivity ca (nolock)
		Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
		Left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Where
		ca.AssignedUserKey = @UserKey and 
		ca.ActivityDate < DATEADD(dd, 14, @CurDate) and
		ca.ActivityDate > DATEADD(dd,-14, @CurDate)  and
		ca.Status = 1
	Order By ActivityDate DESC, ca.Subject
GO
