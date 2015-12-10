USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tStandardText (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey
		Order By Type, TextName

	RETURN 1
GO
