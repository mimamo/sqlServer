USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecGet]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecGet]
	@RequestDefSpecKey int

AS --Encrypt

		SELECT *
		FROM tRequestDefSpec (NOLOCK) 
		WHERE
			RequestDefSpecKey = @RequestDefSpecKey

	RETURN 1
GO
