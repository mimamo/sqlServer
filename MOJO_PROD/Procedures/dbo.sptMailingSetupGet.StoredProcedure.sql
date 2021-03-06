USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingSetupGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingSetupGet]
	(
	@CompanyKey INT 
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
|| 02/03/09  QMD 10.5  Added AutoSync Select Statement
*/
	IF(@CompanyKey = -1)
		SELECT	*
		FROM	tMailingSetup (NOLOCK)
		WHERE	AutoSync = 1
	ELSE
		SELECT	*
		FROM	tMailingSetup (NOLOCK)
		WHERE	CompanyKey = @CompanyKey
GO
