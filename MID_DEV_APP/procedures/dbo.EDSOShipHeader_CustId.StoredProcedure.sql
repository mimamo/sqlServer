USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_CustId]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_CustId] @CpnyId varchar(10), @ShipperID varchar(15) As
Select CustId From SOShipHeader Where CpnyId = @CpnyId And ShipperID = @ShipperID
GO
