USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaPremiumGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaPremiumGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/10/13 MFT 10.571  Created
*/

SELECT
	cmp.CompanyMediaKey,
	mp.*
FROM
	tCompanyMediaPremium cmp (nolock)
	INNER JOIN tMediaPremium mp (nolock) ON cmp.MediaPremiumKey = mp.MediaPremiumKey
WHERE
	cmp.CompanyMediaKey = @CompanyMediaKey
GO
