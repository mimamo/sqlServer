USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tCBCode (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By Active DESC, CBCode

	RETURN 1
GO
