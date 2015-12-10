USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckFormatGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckFormatGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCheckFormat (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By FormatName

	RETURN 1
GO
