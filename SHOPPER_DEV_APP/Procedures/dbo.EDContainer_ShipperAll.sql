USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_ShipperAll]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_ShipperAll] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId Order By CpnyId, ShipperId, ContainerId
GO
