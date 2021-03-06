USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_Site]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipHeader_Site]  @ShipperId varchar(15) AS
Select A.ShipperId,A.SiteId,A.ShipAddr1,A.ShipAddr2,A.ShipCity,A.ShipCountry,A.ShipName,
 A.ShipState,A.ShipZip,B.Addr1,B.Addr2,B.City,B.Country,B.Name,B.State,B.Zip,A.CustID
 from SOShipHeader A, Site B
 where A.ShipperId = @ShipperId and A.SiteId = B.SiteId
GO
