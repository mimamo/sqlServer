USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_Count]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_Count] @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
