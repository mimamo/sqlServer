USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupGetBySecurityGroup]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupGetBySecurityGroup]
	@SecurityGroupKey int
AS --Encrypt

	SELECT	*, '' AS Description --Used in the code to add the ViewName from the XML file
	FROM	tViewSecurityGroup (NOLOCK)
	WHERE	SecurityGroupKey = @SecurityGroupKey
	
	RETURN 1
GO
