USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseAssignmentInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseAssignmentInsert]
	@CompanyKey int,
	@ContactDatabaseKey int
AS --Encrypt

if not exists(Select 1 from tContactDatabaseAssignment (nolock) 
	Where CompanyKey = @CompanyKey and ContactDatabaseKey = @ContactDatabaseKey)
	
	INSERT tContactDatabaseAssignment
		(
		CompanyKey,
		ContactDatabaseKey
		)

	VALUES
		(
		@CompanyKey,
		@ContactDatabaseKey
		)

	RETURN 1
GO
