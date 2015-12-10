USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUserServicesGet]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUserServicesGet]
	(
		@ProjectKey INT
	)
	
AS -- Encrypt

	SET NOCOUNT ON 

	SELECT *
	FROM   tProjectUserServices (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
		
	RETURN
GO
