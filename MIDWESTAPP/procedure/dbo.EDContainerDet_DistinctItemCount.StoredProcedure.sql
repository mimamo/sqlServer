USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_DistinctItemCount]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_DistinctItemCount] @CpnyId varchar(10), @ShipperId varchar(15), @ContainerId varchar(10) As
Select Count(Distinct InvtId), Count(*) From EDContainerDet Where CpnyId = @CpnyId And ShipperId = @ShipperId
And ContainerId = @ContainerId
GO
