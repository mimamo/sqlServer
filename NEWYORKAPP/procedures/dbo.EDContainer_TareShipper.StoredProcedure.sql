USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TareShipper]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[EDContainer_TareShipper] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag <> 0
Order By CpnyId,ShipperId,ContainerId
GO
