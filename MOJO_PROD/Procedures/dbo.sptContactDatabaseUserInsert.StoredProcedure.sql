USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseUserInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseUserInsert]
	@ContactDatabaseKey int,
	@UserKey int
AS --Encrypt

	INSERT tContactDatabaseUser
		(
		ContactDatabaseKey,
		UserKey
		)

	VALUES
		(
		@ContactDatabaseKey,
		@UserKey
		)
GO
