USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecGetList]

	@RequestDefKey int


AS --Encrypt

		SELECT *
		FROM tRequestDefSpec (NOLOCK) 
		WHERE
		RequestDefKey = @RequestDefKey
		Order By DisplayOrder

	RETURN 1
GO
