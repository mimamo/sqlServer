USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_CountSum]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_CountSum] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*), Sum(QtyShip) From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
