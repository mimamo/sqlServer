USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStatusGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tLeadStatus (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By
		DisplayOrder

	RETURN 1
GO
