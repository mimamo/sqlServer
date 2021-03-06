USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_InvtIdLotSerNbr]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_InvtIdLotSerNbr] @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.InvtId, A.LotSerNbr From EDContainerDet A, Inventory B Where A.CpnyId = @CpnyId And
A.ShipperId = @ShipperId And A.InvtId = B.InvtId And B.LotSerTrack = 'SI'
Order By A.InvtId, A.LotSerNbr
GO
