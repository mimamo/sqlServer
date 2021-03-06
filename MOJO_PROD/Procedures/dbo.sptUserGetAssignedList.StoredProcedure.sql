USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetAssignedList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetAssignedList]

	(
		@CompanyKey int
	)

AS --Encrypt

	Select Distinct
		u.FirstName + ' ' + u.LastName as UserName,
		u.LastName,
		u.UserKey
	from
		tUser u (nolock),
		tAssignment ta (nolock),
		tProject p (nolock)
	Where
		u.UserKey = ta.UserKey and
		ta.ProjectKey = p.ProjectKey and
		u.Active = 1 and
		p.CompanyKey = @CompanyKey
	Order By u.LastName
GO
