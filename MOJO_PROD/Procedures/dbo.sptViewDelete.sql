USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewDelete]
	@ViewKey int

AS --Encrypt

	DELETE
	FROM tView
	WHERE
		ViewKey = @ViewKey 

	RETURN 1
GO
