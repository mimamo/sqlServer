USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_CompanyMediaP]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_CompanyMediaP]
AS

/*
|| When     Who Rel     What
|| 03/14/14 PLC 10.578  Created to Split Radio TV Print OOH Interactive
|| 10/29/14 GHL 10.585  Added sales taxes to help out with new media report testing
|| 12/11/14 GHL 10.587  Added Insertion Order Address at SM's request
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
	
	,cm.Address1 as [Insertion Order Address 1]
	,cm.Address2 as [Insertion Order Address 2]
	,cm.Address3 as [Insertion Order Address 3]
	,cm.City as [Insertion Order City]
	,cm.State as [Insertion Order State]
	,cm.PostalCode as [Insertion Order Postal Code]
	,cm.Country as [Insertion Order Country]
	,cm.Phone as [Insertion Order Phone]
	,cm.Fax as [Insertion Order Fax]
	
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
	,cm.MMaterials as [Materials/Notes]
	,CASE cm.PrintMaterialsInfo
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END as [Print Materials Info]	
	,mc.CategoryID as [Category ID]
	,mc.CategoryName as [Category Name]
	,ut.UnitTypeID as [Unit Type ID]
	,ut.UnitTypeName as [Unit Type Name]
	,cm.Frequency as [Frequency]
	,cm.URL 
	,st.SalesTaxID as [Sales Tax ID]
	,st2.SalesTaxID as [Sales Tax 2 ID]
FROM 	tCompanyMedia cm (nolock)
INNER JOIN tCompany c (nolock) ON cm.VendorKey = c.CompanyKey 
left outer join tMediaMarket mm (nolock) ON cm.MediaMarketKey = mm.MediaMarketKey 	
left outer join tMediaCategory mc (nolock) on cm.MediaCategoryKey = mc.MediaCategoryKey
left outer join tMediaUnitType ut (nolock)  on cm.DefaultMediaUnitTypeKey = ut.MediaUnitTypeKey
left outer join tItem i (nolock) on cm.ItemKey = i.ItemKey
left outer join tSalesTax st (nolock) on cm.SalesTaxKey = st.SalesTaxKey
left outer join tSalesTax st2 (nolock) on cm.SalesTax2Key = st2.SalesTaxKey
GO
