USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupDelete]
	@ViewKey int,
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/23/06 CRG 8.35  Added CompanyKey so that other companys' Views don't get removed
*/

	DELETE	tViewSecurityGroup
	WHERE	ViewKey = @ViewKey
	AND		SecurityGroupKey IN 
				(SELECT SecurityGroupKey
				FROM	tSecurityGroup (nolock)
				WHERE	CompanyKey = @CompanyKey)
	
	RETURN 1
GO
