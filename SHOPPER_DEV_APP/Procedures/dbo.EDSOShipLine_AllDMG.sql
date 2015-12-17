USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_AllDMG] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select * From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId And LineRef = @LineRef
GO
