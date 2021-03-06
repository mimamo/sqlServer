USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_InfoFor856]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_InfoFor856] @ContainerId varchar(30), @LineRef varchar(5) As
Select A.LotSerRef, A.LotSerNbr, A.BoxRef, B.QtyPicked, B.QtyShipped, B.UOM, A.WhseLoc,
  A.User1, A.User2, A.User3, A.User4, A.User5, A.User6, A.User7, A.User8, A.User9, A.User10
  From SOShipLot A Inner Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperID =
  B.ShipperId And A.LineRef = B.LineRef And A.LotSerNbr = B.LotSerNbr And A.WhseLoc = B.WhseLoc
  Where B.ContainerId = @ContainerId And B.LineRef = @LineRef
  Order By A.LotSerRef
GO
