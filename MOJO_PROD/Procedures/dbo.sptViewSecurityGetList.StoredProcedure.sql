USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGetList]
	@CompanyKey int,
	@ViewKey int
AS

	SELECT	sg.*
	FROM	tSecurityGroup sg (NOLOCK)
	INNER JOIN tViewSecurityGroup vsg (NOLOCK) ON sg.SecurityGroupKey = vsg.SecurityGroupKey AND sg.CompanyKey = @CompanyKey
	WHERE	vsg.ViewKey = @ViewKey
	ORDER BY GroupName
GO
