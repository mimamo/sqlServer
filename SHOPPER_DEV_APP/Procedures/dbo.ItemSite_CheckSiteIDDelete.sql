USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_CheckSiteIDDelete]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ItemSite_CheckSiteIDDelete]
	@parmSiteID varchar (10)
as
Select * From ItemSite where SiteID = @parmSiteID and
	(QtyOnHand <> 0 Or
         QtyOnPO <> 0 Or
         QtyOnKitAssyOrders <> 0 Or
         QtyOnTransferOrders <> 0 Or
         QtyWOFirmSupply <> 0 Or
         QtyWORlsedSupply <> 0 Or
         QtyCustOrd <> 0 Or
         QtyOnBO <> 0 Or
         QtyAlloc <> 0 Or
         QtyShipNotInv <> 0 Or
         QtyWOFirmDemand <> 0 Or
         QtyWORlsedDemand <> 0 Or
         TotCost <> 0)
GO
