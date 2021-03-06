USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetOfficeList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetOfficeList]

	(
		@CompanyKey int,
		@OfficeKey int,
		@DepartmentKey int,
		@EmployeeKey int
	)

AS --Encrypt


IF @EmployeeKey = 0
	IF @OfficeKey = 0
		if @DepartmentKey = 0
			Select DISTINCT u.UserKey, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName 
			from tUser u (nolock), vTaskAssignment ta (nolock)
			Where 
				ta.CompanyKey = @CompanyKey and
				u.UserKey = ta.UserKey
			Order By UserName
		else
			Select DISTINCT u.UserKey, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName 
			from tUser u (nolock), vTaskAssignment ta (nolock)
			Where 
				ta.CompanyKey = @CompanyKey and
				u.UserKey = ta.UserKey and
				u.DepartmentKey = @DepartmentKey
			Order By UserName
	else
		if @DepartmentKey = 0
			Select DISTINCT u.UserKey, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName 
			from tUser u (nolock), vTaskAssignment ta (nolock)
			Where 
				ta.CompanyKey = @CompanyKey and
				u.UserKey = ta.UserKey and
				u.OfficeKey = @OfficeKey
			Order By UserName
		else
			Select DISTINCT u.UserKey, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName 
			from tUser u (nolock), vTaskAssignment ta (nolock)
			Where 
				ta.CompanyKey = @CompanyKey and
				u.UserKey = ta.UserKey and
				u.OfficeKey = @OfficeKey and
				u.DepartmentKey = @DepartmentKey
			Order By UserName
else
	Select DISTINCT u.UserKey, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName 
	from tUser u (nolock), vTaskAssignment ta (nolock)
	Where 
		ta.UserKey = @EmployeeKey and
		u.UserKey = ta.UserKey
	Order By UserName
GO
