USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingSetupDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingSetupDelete]
	(
	@CompanyKey INT
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
*/

	DELETE	tMailingSetup 
	WHERE	CompanyKey = @CompanyKey
GO
