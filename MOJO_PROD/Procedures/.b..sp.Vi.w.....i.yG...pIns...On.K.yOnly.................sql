USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupInsertOneKeyOnly]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupInsertOneKeyOnly]
	@ViewKey int,
	@SecurityGroupKey int
AS --Encrypt

	IF NOT EXISTS
			(SELECT	NULL
			FROM	tViewSecurityGroup
			WHERE	ViewKey = @ViewKey
			AND		SecurityGroupKey = @SecurityGroupKey)
		INSERT	tViewSecurityGroup (ViewKey, SecurityGroupKey)
		VALUES	(@ViewKey, @SecurityGroupKey)
	 
	RETURN 1
GO
