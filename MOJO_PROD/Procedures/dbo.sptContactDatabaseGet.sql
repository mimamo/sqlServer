USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactDatabaseGet]
	@ContactDatabaseKey int

AS --Encrypt

		SELECT *
		FROM tContactDatabase (nolock)
		WHERE
			ContactDatabaseKey = @ContactDatabaseKey

	RETURN 1
GO
