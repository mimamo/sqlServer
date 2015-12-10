USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaGet]
	@CompanyMediaKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/19/13 MFT 10.569  Changed tCompany to OUTER join so rows with no VendorKey will appear
|| 07/10/13 GWG 10.570  Added two more lookup fields
|| 02/05/14 PLC 10.576  Added Affiliate
|| 10/02/14 GHL 10.584  Added taxes
*/

SELECT 
	 cm.*	
	,c.CompanyName
	,c.VendorID
	,mm.MarketName
	,mm.MarketID
	,i.ItemID
	,i.ItemName
	,mc.CategoryID
	,mc.CategoryName
	,ut.UnitTypeID
	,ut.UnitTypeName
	,ma.AffiliateName
	,ma.AffiliateID
	,st.SalesTaxID
	,st.SalesTaxName
	,st2.SalesTaxID as SalesTaxID2
	,st2.SalesTaxName as SalesTaxName2

FROM 	
	tCompanyMedia cm (nolock)
	LEFT JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
	left outer join tMediaMarket mm (nolock) ON cm.MediaMarketKey = mm.MediaMarketKey 	
	left outer join tMediaAffiliate ma (nolock) ON cm.MediaAffiliateKey = ma.MediaAffiliateKey 	
	left outer join tMediaCategory mc (nolock) on cm.MediaCategoryKey = mc.MediaCategoryKey
	left outer join tMediaUnitType ut (nolock)  on cm.DefaultMediaUnitTypeKey = ut.MediaUnitTypeKey
	left outer join tItem i (nolock) on cm.ItemKey = i.ItemKey
	left outer join tSalesTax st (nolock) on cm.SalesTaxKey = st.SalesTaxKey
	left outer join tSalesTax st2 (nolock) on cm.SalesTax2Key = st2.SalesTaxKey

WHERE
	cm.CompanyMediaKey = @CompanyMediaKey	

	RETURN 1
GO
