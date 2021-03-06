USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractGetList]
	@CompanyMediaKey int
	
AS

/*
|| When     Who Rel     What
|| 02/27/14 PLC 10.577  Added UnitTypeName so Publication window could use it.
*/
--SELECT
--	*
--FROM
--	tCompanyMediaContract (nolock)
--WHERE
--	CompanyMediaKey = @CompanyMediaKey

SELECT
	cc.*,
	cm.StationID as StationID,
	cm.Name AS CompanyMediaName,
	cm.MediaKind as MKind,
	mu.UnitTypeID,
	mu.UnitTypeName as UnitTypeName 
FROM
	tCompanyMediaContract cc (nolock)
	INNER JOIN tCompanyMedia cm (nolock) ON cc.CompanyMediaKey = cm.CompanyMediaKey
	LEFT JOIN tMediaUnitType mu (nolock) ON cc.MediaUnitTypeKey = mu.MediaUnitTypeKey
WHERE cc.CompanyMediaKey = @CompanyMediaKey
GO
