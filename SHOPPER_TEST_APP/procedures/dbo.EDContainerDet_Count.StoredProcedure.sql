USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_Count]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_Count] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From EDContainerDet Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
