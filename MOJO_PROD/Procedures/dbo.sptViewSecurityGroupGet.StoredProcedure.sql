USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupGet]
	@ViewKey int
AS --Encrypt

	SELECT	*
	FROM	tViewSecurityGroup
	WHERE	ViewKey = @ViewKey
	
	RETURN 1
GO
