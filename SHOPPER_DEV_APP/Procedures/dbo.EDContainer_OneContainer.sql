USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_OneContainer]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_OneContainer] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And ContainerId = @ContainerId
GO
