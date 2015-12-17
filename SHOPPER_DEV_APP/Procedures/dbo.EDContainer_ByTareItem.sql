USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_ByTareItem]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_ByTareItem] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10), @InvtId varchar(30) As
Select A.ContainerId, B.QtyShipped, B.LotSerNbr, B.WhseLoc, B.LineNbr, B.UOM From EDContainer A Inner Join EDContainerDet B On A.CpnyId = B.CpnyId
And A.ShipperId = B.ShipperId And A.ContainerId = B.ContainerId Where A.CpnyId = @CpnyId And
A.ShipperId = @ShipperId And A.TareId = @TareId And B.InvtId = @InvtId
GO
