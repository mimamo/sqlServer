USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUserServicesInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUserServicesInsert]
	(
	@ProjectKey INT	
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	-- Assume done in ASP
	-- CREATE TABLE #tUserService (UserKey int null, ServiceKey int null)
	
	DELETE tProjectUserServices WHERE ProjectKey = @ProjectKey
	
	INSERT tProjectUserServices (ProjectKey, UserKey, ServiceKey)
	SELECT @ProjectKey, UserKey, ServiceKey
	FROM   #tUserService
	
	RETURN 1
GO
