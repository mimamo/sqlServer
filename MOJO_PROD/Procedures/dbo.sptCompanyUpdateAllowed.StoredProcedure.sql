USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateAllowed]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateAllowed]

	(
		@CompanyKey int,
		@UserKey int
	)

AS

Declare @OwnerCompanyKey int

if not exists(select 1 from tContactDatabaseAssignment (nolock) Where CompanyKey = @CompanyKey)
	return 1
	

if exists(Select 1 from tContactDatabaseAssignment cda (nolock)
			inner join tContactDatabaseUser cdu (nolock) 
				on cda.ContactDatabaseKey = cdu.ContactDatabaseKey
			Where	cda.CompanyKey = @CompanyKey 
			and		cdu.UserKey = @UserKey)
	return 1
else
	return 0
GO
