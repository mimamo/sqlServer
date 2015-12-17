USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_InvtIdChk]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLine_InvtIdChk] @InvtId varchar(30), @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.* From Inventory A, SOShipLine B Where A.InvtId = B.InvtId And A.InvtId = @InvtId And B.CpnyId = @CpnyId And B.ShipperId = @ShipperId
GO
