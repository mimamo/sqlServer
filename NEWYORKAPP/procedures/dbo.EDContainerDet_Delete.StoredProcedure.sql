USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Delete]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_Delete] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Delete From EDContainerDet Where CpnyId = @CpnyId And ShipperId = @ShipperId And ContainerId = @ContainerId
GO
