USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ItemQtyBlank]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_ItemQtyBlank] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select InvtId, Sum(QtyShipped), ' ' From EDContainerDet Where CpnyId = @CpnyId And ShipperId =
@ShipperId And ContainerId = @ContainerId Group By InvtId
GO
