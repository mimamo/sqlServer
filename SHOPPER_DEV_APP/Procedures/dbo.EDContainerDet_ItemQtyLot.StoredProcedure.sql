USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ItemQtyLot]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_ItemQtyLot] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select InvtId, QtyShipped, LotSerNbr From EDContainerDet Where CpnyId = @CpnyId And ShipperId =
@ShipperId And ContainerId = @ContainerId
GO
