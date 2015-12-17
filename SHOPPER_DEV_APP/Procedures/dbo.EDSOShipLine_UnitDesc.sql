USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_UnitDesc]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipLine_UnitDesc] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select LineRef, UnitDesc From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId And LineRef = @LineRef
GO
