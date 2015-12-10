USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingGet]
	(
	@CompanyKey INT
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
*/

	SELECT	*
	FROM	tMailing (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
GO
