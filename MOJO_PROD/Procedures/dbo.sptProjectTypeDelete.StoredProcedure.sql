USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeDelete]
	@ProjectTypeKey int

AS --Encrypt

/*
  || When     Who Rel   What
  || 01/23/12 RLB 10552 (132290) Removed error and null any projects that have that status
  ||                    
  */

DECLARE @CompanyKey int
	SELECT @CompanyKey = CompanyKey FROM tProjectType (NOLOCK) WHERE ProjectTypeKey = @ProjectTypeKey

	--IF EXISTS(SELECT 1 FROM tProject (NOLOCK) WHERE ProjectTypeKey = @ProjectTypeKey AND CompanyKey = @CompanyKey)
		--RETURN -1

	Update tProject set ProjectTypeKey = NULL WHERE ProjectTypeKey = @ProjectTypeKey AND CompanyKey = @CompanyKey

	DELETE
	FROM tProjectTypeService
	WHERE
		ProjectTypeKey = @ProjectTypeKey 
		
	DELETE
	FROM tProjectType
	WHERE
		ProjectTypeKey = @ProjectTypeKey 

	RETURN 1
GO
