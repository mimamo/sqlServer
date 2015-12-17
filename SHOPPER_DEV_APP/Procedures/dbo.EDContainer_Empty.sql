USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_Empty]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_Empty] @CpnyId varchar(10), @ShipperId varchar(15) As
Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And
TareFlag = 0 And ContainerId Not In (Select Distinct ContainerId From EDContainerDet Where
CpnyId = @CpnyId And ShipperId = @ShipperId)
GO
