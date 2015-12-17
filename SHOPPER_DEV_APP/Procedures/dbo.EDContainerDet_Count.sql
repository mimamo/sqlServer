USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Count]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_Count] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From EDContainerDet Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
