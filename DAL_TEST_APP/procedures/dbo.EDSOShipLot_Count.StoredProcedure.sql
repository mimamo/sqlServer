USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_Count]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLot_Count] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select Count(*) From SOShipLot Where CpnyId = @CpnyId And ShipperId = @ShipperId And LineRef = @LineRef
GO
