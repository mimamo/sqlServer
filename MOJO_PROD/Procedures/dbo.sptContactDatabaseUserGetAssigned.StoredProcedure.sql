USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseUserGetAssigned]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptContactDatabaseUserGetAssigned]

	(
		@ContactDatabaseKey int
	)

AS --Encrypt


	Select 
		u.FirstName + ' ' + u.LastName as UserName,
		u.UserKey
	from
		tUser u (nolock),
		tContactDatabaseUser cdu (nolock)
	Where
		u.UserKey = cdu.UserKey and
		cdu.ContactDatabaseKey = @ContactDatabaseKey
	Order By u.LastName
GO
