USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_NbrItemsSumQty]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_NbrItemsSumQty] @ContainerId varchar(10) As
Select Count(Distinct InvtId), Count(Distinct UOM), Sum(QtyShipped) From EDContainerDet Where
ContainerId = @ContainerId
GO
