USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusDelete]
	@ProjectBillingStatusKey int


AS --Encrypt

DECLARE @CompanyKey int

	SELECT @CompanyKey = CompanyKey FROM tProjectBillingStatus (NOLOCK) WHERE ProjectBillingStatusKey = @ProjectBillingStatusKey

	IF EXISTS(SELECT 1 From tProject (NOLOCK) WHERE ProjectBillingStatusKey = @ProjectBillingStatusKey AND CompanyKey = @CompanyKey)
		RETURN -1

	DELETE
	FROM tProjectBillingStatus
	WHERE
		ProjectBillingStatusKey = @ProjectBillingStatusKey 

	RETURN 1
GO
