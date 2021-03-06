USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusGetList]
	@CompanyKey int

AS --Encrypt

	SELECT 
		tProjectStatus.*,
		ProjectStatus as DisplayName
	FROM tProjectStatus (NOLOCK) 
	WHERE
		CompanyKey = @CompanyKey
	ORDER BY
		DisplayOrder

	RETURN 1
GO
