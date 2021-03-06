USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseInsert]
	@CompanyKey int,
	@DatabaseID varchar(50),
	@DatabaseName varchar(300),
	@oIdentity INT OUTPUT
AS --Encrypt

If exists(Select 1 from tContactDatabase (nolock) Where DatabaseID = @DatabaseID and CompanyKey = @CompanyKey) 
	return -1 

	INSERT tContactDatabase
		(
		CompanyKey,
		DatabaseID,
		DatabaseName
		)

	VALUES
		(
		@CompanyKey,
		@DatabaseID,
		@DatabaseName
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
