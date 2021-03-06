USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRoleUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserRoleUpdate]
	@UserRoleKey int,
	@CompanyKey int,
	@UserRole varchar(300)

AS --Encrypt
/*
|| When      Who Rel      What
|| 09/09/09  MAS 10.5.0.8 Added insert logic
*/

IF @UserRoleKey <=0
	BEGIN
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
		
		RETURN @@IDENTITY

	END
ELSE
	BEGIN
		UPDATE
			tUserRole
		SET
			CompanyKey = @CompanyKey,
			UserRole = @UserRole
		WHERE
			UserRoleKey = @UserRoleKey 

		RETURN @UserRoleKey
	END
GO
