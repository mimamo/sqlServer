USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarTypeGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarTypeGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCalendarType (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By DisplayOrder

	RETURN 1
GO
