USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusGet]
	@ProjectBillingStatusKey int

AS --Encrypt

		SELECT *
		FROM tProjectBillingStatus (NOLOCK) 
		WHERE
			ProjectBillingStatusKey = @ProjectBillingStatusKey

	RETURN 1
GO
