USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tContactDatabase (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By DatabaseID

	RETURN 1
GO
