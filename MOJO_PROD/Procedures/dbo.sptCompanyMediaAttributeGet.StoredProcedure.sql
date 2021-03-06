USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaAttributeGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaAttributeGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 08/23/13 MFT 10.571  Created
|| 08/27/13 MFT 10.571  Added ISNULL to filters to return all when no @CompanyMediaKey
*/

DECLARE
	@CompanyKey int,
	@POKind tinyint
SELECT
	@CompanyKey = CompanyKey,
	@POKind = MediaKind
FROM tCompanyMedia
WHERE CompanyMediaKey = @CompanyMediaKey

SELECT
	ma.MediaAttributeKey,
	ma.AttributeName,
	mav.MediaAttributeValueKey,
	mav.ValueName,
	CASE WHEN ISNULL(cma.MediaAttributeValueKey, 0) > 0 THEN 1 ELSE 0 END AS Selected
FROM
	tMediaAttribute ma (nolock)
	INNER JOIN tMediaAttributeValue mav (nolock)
		ON ma.MediaAttributeKey = mav.MediaAttributeKey
	LEFT JOIN tCompanyMediaAttributeValue cma (nolock)
		ON mav.MediaAttributeValueKey = cma.MediaAttributeValueKey AND
		ISNULL(cma.CompanyMediaKey, 0) = ISNULL(@CompanyMediaKey, 0)
WHERE
	ma.POKind = ISNULL(@POKind, ma.POKind) AND
	ma.CompanyKey = ISNULL(@CompanyKey, ma.CompanyKey)
GO
