USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckFormatGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckFormatGet]
	@CheckFormatKey int

AS --Encrypt

		SELECT *
		FROM tCheckFormat (nolock)
		WHERE
			CheckFormatKey = @CheckFormatKey

	RETURN 1
GO
