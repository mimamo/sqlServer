USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckMethodGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckMethodGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCheckMethod (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By CheckMethod

	RETURN 1
GO
