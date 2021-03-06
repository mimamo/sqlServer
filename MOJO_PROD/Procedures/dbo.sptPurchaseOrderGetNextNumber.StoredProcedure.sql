USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetNextNumber]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderGetNextNumber]

	(
		@CompanyKey int
	)

AS --Encrypt

SELECT 
	PONumPrefix,
	NextPONum,
	ISNULL(PONumPlaces, 0) as PONumPlaces
FROM
	tPreference (NOLOCK) 
WHERE
	CompanyKey = @CompanyKey
GO
