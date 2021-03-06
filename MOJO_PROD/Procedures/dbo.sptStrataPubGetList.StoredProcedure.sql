USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataPubGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataPubGetList]
	(
		@CompanyKey int
	)
as --Encrypt


select cm.CompanyMediaKey
      ,cm.CompanyKey
      ,co.VendorID as VendorID
      ,cm.Name as StationName
      ,cm.StationID
      ,i.LinkID as MediaLinkID
      ,mm.LinkID as MarketLinkID
      ,cm.Address1
      ,cm.Address2
      ,cm.Address3
      ,cm.City
      ,cm.State
      ,cm.PostalCode
      ,cm.LinkID
      ,cm.Phone
      ,cm.Fax
      ,cm.MAddress1
      ,cm.MAddress2
      ,cm.MAddress3
      ,cm.MCity
      ,cm.MState
      ,cm.MPostalCode
      ,cm.MPhone
      ,cm.MFax
      ,cm.MEmail
  from tCompanyMedia cm (nolock) inner join tItem i (nolock) on cm.ItemKey = i.ItemKey
       inner join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
       inner join tCompany co (nolock) on cm.VendorKey = co.CompanyKey
 where cm.CompanyKey = @CompanyKey
   and cm.MediaKind = 1
   and cm.Active = 1
GO
