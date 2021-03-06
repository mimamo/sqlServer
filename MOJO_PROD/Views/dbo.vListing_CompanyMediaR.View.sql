USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_CompanyMediaR]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_CompanyMediaR]
AS

/*
|| When     Who Rel     What
|| 03/14/14 PLC 10.578  Created to Split Radio TV Print OOH Interactive
*/

SELECT 
	cm.CompanyMediaKey
	,cm.CompanyKey
	,c.CompanyName AS [Vendor Name]
	,c.VendorID AS [Vendor ID]
	,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
	,cm.MediaKind --No need to show name here because we will always select for one time of MediaKind
	,cm.Name as [Station Name]
	,cm.StationID as [Station ID]
	,cm.Date1Days as [Date1Days]
	,cm.Date2Days as [Date2Days]
	,cm.Date3Days as [Date3Days]
	,cm.Date4Days as [Date4Days]
	,cm.Date5Days as [Date5Days]
	,cm.Date6Days as [Date6Days]
	,mm.MarketName as [Media Market Name]
	,mm.MarketID as [Media Market ID]
	,i.ItemID as [Item ID]
	,i.ItemName as [Item Name]
	,CASE cm.Active
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END as Active
	,cm.Contact
	,cm.Address1 as [Mailing Address 1]
	,cm.Address2 as [Mailing Address 2]
	,cm.Address3 as [Mailing Address 3]
	,cm.City as [Mailing City]
	,cm.State as [Mailing State]
	,cm.PostalCode as [Mailing Postal Code]
	,cm.Country as [Mailing Country]
	,cm.Phone as [Mailing Phone]
	,cm.Fax as [Mailing Fax]
	,cm.MAddress1 as [Materials Address 1]
	,cm.MAddress2 as [Materials Address 2]
	,cm.MAddress3 as [Materials Address 3]
	,cm.MCity as [Materials City]
	,cm.MState as [Materials State]
	,cm.MPostalCode as [Materials Postal Code]
	,cm.MCountry as [Materials Country]
	,cm.MPhone as [Materials Phone]
	,cm.MFax as [Materials Fax]
	,cm.MEmail as [Materials Email]
	,mc.CategoryID as [Category ID]
	,mc.CategoryName as [Category Name]
	,ma.AffiliateID as [Affiliate ID]
	,ma.AffiliateName as [Affiliate Name]
	,cm.Channel as [Channel]
FROM 	tCompanyMedia cm (nolock)
INNER JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
left outer join tMediaMarket mm (nolock) ON cm.MediaMarketKey = mm.MediaMarketKey 	
left outer join tMediaCategory mc (nolock) on cm.MediaCategoryKey = mc.MediaCategoryKey
left outer join tMediaAffiliate ma (nolock) on cm.MediaAffiliateKey = ma.MediaAffiliateKey
left outer join tItem i (nolock) on cm.ItemKey = i.ItemKey
GO
