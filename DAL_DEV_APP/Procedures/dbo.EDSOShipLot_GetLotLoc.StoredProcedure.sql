USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_GetLotLoc]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLot_GetLotLoc] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5), @LotSerRef varchar(5) As
Select LotSerNbr, WhseLoc From SOShipLot Where CpnyId = @CpnyId And ShipperId = @ShipperId And
LineRef = @LineRef And LotSerRef = @LotSerRef
GO
