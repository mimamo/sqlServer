USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_DistinctItemCount]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_DistinctItemCount] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select Count(Distinct InvtId), Count(*) From EDContainerDet Where CpnyId = @CpnyId And ShipperId = @ShipperId
And ContainerId = @ContainerId
GO
