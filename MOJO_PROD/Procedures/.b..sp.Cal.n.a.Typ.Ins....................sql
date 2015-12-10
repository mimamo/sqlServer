USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarTypeInsert]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarTypeInsert]
	@CompanyKey int,
	@TypeName varchar(200),
	@TypeColor varchar(50),
	@DisplayOrder int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tCalendarType
		(
		CompanyKey,
		TypeName,
		TypeColor,
		DisplayOrder
		)

	VALUES
		(
		@CompanyKey,
		@TypeName,
		@TypeColor,
		@DisplayOrder
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
