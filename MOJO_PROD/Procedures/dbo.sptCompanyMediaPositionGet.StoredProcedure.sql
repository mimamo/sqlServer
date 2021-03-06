USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaPositionGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaPositionGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/10/13 MFT 10.569  Created
*/

SELECT
	cmp.CompanyMediaKey,
	mp.*
FROM
	tCompanyMediaPosition cmp (nolock)
	INNER JOIN tMediaPosition mp (nolock) ON cmp.MediaPositionKey = mp.MediaPositionKey 
WHERE
	cmp.CompanyMediaKey = @CompanyMediaKey
GO
