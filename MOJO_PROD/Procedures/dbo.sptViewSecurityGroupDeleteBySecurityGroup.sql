USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupDeleteBySecurityGroup]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupDeleteBySecurityGroup]
	@SecurityGroupKey int
AS --Encrypt

	DELETE	tViewSecurityGroup
	WHERE	SecurityGroupKey = @SecurityGroupKey
	
	RETURN 1
GO
