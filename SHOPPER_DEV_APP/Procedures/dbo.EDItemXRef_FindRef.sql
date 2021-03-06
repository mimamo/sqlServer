USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_FindRef]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_FindRef] @CpnyId varchar(10), @ShipperId varchar(15), @EntityId varchar(15), @AlternateId varchar(30) As
Select Count(*), Max(InvtId) From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId And
(Select Count(*) From ItemXRef Where ItemXRef.InvtId = SOShipLine.InvtId And AlternateId = @AlternateId And EntityId In (@EntityId, '*')) = 1
GO
