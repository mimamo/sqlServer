USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_InvtIdChk]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_InvtIdChk] @InvtId varchar(30), @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.* From Inventory A, SOShipLine B Where A.InvtId = B.InvtId And A.InvtId = @InvtId And B.CpnyId = @CpnyId And B.ShipperId = @ShipperId
GO
