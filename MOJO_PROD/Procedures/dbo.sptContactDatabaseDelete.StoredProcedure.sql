USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseDelete]
	@ContactDatabaseKey int

AS --Encrypt


	DELETE
	FROM tContactDatabaseUser
	WHERE
		ContactDatabaseKey = @ContactDatabaseKey
		
	DELETE
	FROM tContactDatabaseAssignment
	WHERE
		ContactDatabaseKey = @ContactDatabaseKey 

	DELETE
	FROM tContactDatabase
	WHERE
		ContactDatabaseKey = @ContactDatabaseKey 

	RETURN 1
GO
