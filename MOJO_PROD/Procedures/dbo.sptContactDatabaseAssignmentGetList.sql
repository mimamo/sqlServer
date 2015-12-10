USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseAssignmentGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptContactDatabaseAssignmentGetList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select 
	cd.DatabaseID,
	cd.DatabaseName,
	cd.ContactDatabaseKey
from
	tContactDatabase cd (nolock),
	tContactDatabaseAssignment cda (nolock)
Where
	cd.ContactDatabaseKey = cda.ContactDatabaseKey and
	cda.CompanyKey = @CompanyKey
Order By DatabaseID
GO
