USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_TicketMapDetails]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_TicketMapDetails] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select InvtId, QtyShipped, LotSerNbr, WhseLoc, LineNbr From EDContainerDet Where CpnyId = @CpnyId
And ShipperId = @ShipperId And ContainerId = @ContainerId Order By CpnyId, ShipperId, ContainerId, LineNbr
GO
