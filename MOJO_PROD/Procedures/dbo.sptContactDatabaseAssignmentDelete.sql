USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseAssignmentDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseAssignmentDelete]
	@CompanyKey int

AS --Encrypt

	DELETE
	FROM tContactDatabaseAssignment
	WHERE
		CompanyKey = @CompanyKey 

	RETURN 1
GO
