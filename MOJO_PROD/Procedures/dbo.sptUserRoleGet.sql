USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRoleGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptUserRoleGet]
	@UserRoleKey int

AS --Encrypt

		SELECT *
		FROM tUserRole (nolock)
		WHERE
			UserRoleKey = @UserRoleKey

	RETURN 1
GO
