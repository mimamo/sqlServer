USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingSetupInitialized]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingSetupInitialized]
	(
	@CompanyKey INT
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Create to determine if the addFields process needs to run with myemma
*/

DECLARE @Return TINYINT 

SET @Return = 1

	IF EXISTS (SELECT *	FROM tMailingSetup (NOLOCK) WHERE CompanyKey = @CompanyKey)
		SELECT @Return = Initialized FROM tMailingSetup (NOLOCK) WHERE CompanyKey = @CompanyKey
	
	RETURN @Return
GO
