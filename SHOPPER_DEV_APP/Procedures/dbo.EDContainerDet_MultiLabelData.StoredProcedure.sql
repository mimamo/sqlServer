USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_MultiLabelData]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainerDet_MultiLabelData] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10), @CustId varchar(15) As
Select A.InvtId, A.QtyShipped, Case IsNull(B.AlternateId,'') When '' Then C.AlternateId Else B.AlternateId End,
Case IsNull(D.AlternateId,'') When '' Then E.AlternateId Else D.AlternateId End,
A.UOM, F.StkUnit, F.ClassId From EDContainerDet A Left Outer Join
EDItemXRefOneEntityRef B On A.InvtId = B.InvtId And B.EntityId = @CustId And B.AltIdType = 'U' Left Outer Join EDItemXRef_MaxGlobal C On A.InvtId = C.InvtId And C.AltIdType = 'U' Left Outer Join
EDItemXRefOneEntityRef D On A.InvtId = D.InvtId And D.EntityId = @CustId And D.AltIdType = 'C' Left Outer Join EDItemXRef_MaxGlobal E On A.InvtId = E.InvtId And E.AltIdType = 'C'
Inner Join Inventory F On A.InvtId = F.InvtId Where A.CpnyId = @CpnyId And
A.ShipperId = @ShipperId And A.ContainerId = @ContainerId
GO
