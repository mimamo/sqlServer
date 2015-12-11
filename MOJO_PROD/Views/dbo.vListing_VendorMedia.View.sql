USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_VendorMedia]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vListing_VendorMedia]

as

select


c.CompanyName as [Company Name]
,cm.VendorKey 
,cm.MediaKind as [Media Kind]
,cm.Date1Days as [Date 1 Days]
,cm.Date2Days as [Date2 Days]
,cm.Date3Days as [Date 3 Days]
,cm.Date4Days as [Date 4 Days]
,cm.Date5Days as [Date 5 Days]
,cm.Date6Days as [Date 6 Days]
,cm.MediaMarketKey
,cm.ItemKey
,mm.Active 
,mm.MarketName as [Market Name]
,mm.MarketID 
,mm.LinkID


From 
	tCompanyMedia cm (nolock)
	inner join tCompany c (nolock) on cm.VendorKey = c.CompanyKey
	left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
GO
