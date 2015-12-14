USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseGetUserList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptContactDatabaseGetUserList]

	(
		@UserKey int
	)

AS --Encrypt

Select
	cd.ContactDatabaseKey,
	cd.DatabaseName
From
	tContactDatabase cd (nolock),
	tContactDatabaseUser cdu (nolock)
Where
	cd.ContactDatabaseKey = cdu.ContactDatabaseKey and
	cdu.UserKey = @UserKey
Order By cd.DatabaseName
GO
