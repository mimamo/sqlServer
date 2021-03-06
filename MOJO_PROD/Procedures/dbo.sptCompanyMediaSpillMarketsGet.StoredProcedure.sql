USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaSpillMarketsGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaSpillMarketsGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/26/14 PLC 10.576  Created
|| 01/27/14 GHL 10.576  Fixed queries (changed POKind where clause after talking to PLC)
*/

DECLARE
	@CompanyKey int,
	@POKind int


SELECT
	@CompanyKey = CompanyKey
	,@POKind = MediaKind
FROM tCompanyMedia (nolock)
WHERE CompanyMediaKey = @CompanyMediaKey

/*
select 	ma.MediaMarketKey,
	ma.MarketName, 
	CASE WHEN ISNULL((select MediaMarketKey from tCompanyMediaSpillMarket spl where 
	ma.MediaMarketKey = spl.MediaMarketKey), 0) > 0 THEN 1 ELSE 0 END  AS Selected
from tMediaMarket ma (nolock)
where ma.POKind = ISNULL(2, ma.POKind) AND
	ma.CompanyKey = ISNULL(100, ma.CompanyKey)
*/

-- list of all markets for the company
-- If it is assigned to the company media, mark it as selected

select  mm.MediaMarketKey
	   ,mm.MarketName
	   ,case when cmsm.MediaMarketKey is null then 0 else 1 end as Selected
from    tMediaMarket mm (nolock)
	LEFT OUTER JOIN tCompanyMediaSpillMarket cmsm (nolock) on mm.MediaMarketKey = cmsm.MediaMarketKey 
		and cmsm.CompanyMediaKey = @CompanyMediaKey 
where   mm.CompanyKey = @CompanyKey
and     (mm.POKind is null or mm.POKind = @POKind)
GO
