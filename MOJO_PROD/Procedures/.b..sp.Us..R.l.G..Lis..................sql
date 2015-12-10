USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRoleGetList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptUserRoleGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tUserRole (nolock)
		WHERE
			CompanyKey = @CompanyKey
		ORDER BY
			UserRole

	RETURN 1
GO
