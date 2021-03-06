USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_FindRef]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_FindRef] @CpnyId varchar(10), @ShipperId varchar(15), @EntityId varchar(15), @AlternateId varchar(30) As
Select Count(*), Max(InvtId) From SOShipLine Where CpnyId = @CpnyId And ShipperId = @ShipperId And
(Select Count(*) From ItemXRef Where ItemXRef.InvtId = SOShipLine.InvtId And AlternateId = @AlternateId And EntityId In (@EntityId, '*')) = 1
GO
