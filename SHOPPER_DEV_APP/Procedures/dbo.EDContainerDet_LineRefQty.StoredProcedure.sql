USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_LineRefQty]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_LineRefQty] @ContainerId varchar(10) As
Select LineRef, Sum(QtyShipped) From EDContainerDet Where ContainerId = @ContainerId
  Group By LineRef Order By LineRef
GO
