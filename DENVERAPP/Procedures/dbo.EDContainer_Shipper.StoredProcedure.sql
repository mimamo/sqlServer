USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Shipper]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_Shipper] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And ContainerId Like @ContainerId Order By CpnyId,ShipperId,ContainerId
GO
