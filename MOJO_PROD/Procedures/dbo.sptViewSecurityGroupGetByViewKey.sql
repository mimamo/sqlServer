USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupGetByViewKey]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupGetByViewKey]
	@ViewKey int
AS --Encrypt

	SELECT	*
	FROM	tViewSecurityGroup (NOLOCK)
	WHERE	ViewKey = @ViewKey
	
	RETURN 1
GO
