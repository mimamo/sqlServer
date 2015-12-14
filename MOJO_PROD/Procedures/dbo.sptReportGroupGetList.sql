USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGroupGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGroupGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tReportGroup (NOLOCK) 
		WHERE
		CompanyKey = @CompanyKey
		Order By GroupType, DisplayOrder

	RETURN 1
GO
