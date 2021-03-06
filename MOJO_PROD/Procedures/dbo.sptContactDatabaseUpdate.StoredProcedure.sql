USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseUpdate]
	@ContactDatabaseKey int,
	@CompanyKey int,
	@DatabaseID varchar(50),
	@DatabaseName varchar(300)

AS --Encrypt

If exists(Select 1 from tContactDatabase (nolock) Where DatabaseID = @DatabaseID and CompanyKey = @CompanyKey and ContactDatabaseKey <> @ContactDatabaseKey )
	return -1 

	UPDATE
		tContactDatabase
	SET
		CompanyKey = @CompanyKey,
		DatabaseID = @DatabaseID,
		DatabaseName = @DatabaseName
	WHERE
		ContactDatabaseKey = @ContactDatabaseKey 

	RETURN 1
GO
