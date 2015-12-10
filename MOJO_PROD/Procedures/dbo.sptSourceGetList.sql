USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceGetList]

	@CompanyKey int


AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  QMD 10.5.0.0 Initial Release
*/

		SELECT	*
		FROM	tSource (NOLOCK)
		WHERE	CompanyKey = @CompanyKey
		ORDER BY SourceName

	RETURN 1
GO
