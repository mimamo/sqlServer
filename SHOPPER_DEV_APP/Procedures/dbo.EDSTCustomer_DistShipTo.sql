USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_DistShipTo]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSTCustomer_DistShipTo] @CustId varchar(15), @ShipToId varchar(10) As
Select DistCenterShipToId From EDSTCustomer Where CustId = @CustId And ShipToId = @ShipToId
GO
