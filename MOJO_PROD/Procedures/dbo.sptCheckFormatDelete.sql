USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckFormatDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckFormatDelete]
	@CheckFormatKey int

AS --Encrypt

	DELETE
	FROM tCheckFormat
	WHERE
		CheckFormatKey = @CheckFormatKey 

	RETURN 1
GO
