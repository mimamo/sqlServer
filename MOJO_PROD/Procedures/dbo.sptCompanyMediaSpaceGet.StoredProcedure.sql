USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaSpaceGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaSpaceGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/10/13 MFT 10.569  Created
*/

SELECT
	cms.CompanyMediaKey,
	ms.*
FROM
	tCompanyMediaSpace cms (nolock)
	INNER JOIN tMediaSpace ms (nolock) ON cms.MediaSpaceKey = ms.MediaSpaceKey 
WHERE
	cms.CompanyMediaKey = @CompanyMediaKey
GO
