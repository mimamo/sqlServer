USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRoleInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptUserRoleInsert]
	@CompanyKey int,
	@UserRole varchar(300),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tUserRole
		(
		CompanyKey,
		UserRole
		)

	VALUES
		(
		@CompanyKey,
		@UserRole
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
