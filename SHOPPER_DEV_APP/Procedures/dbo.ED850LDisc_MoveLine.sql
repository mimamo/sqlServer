USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_MoveLine]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_MoveLine] @NewLineId int, @CpnyId varchar(10), @EDIPOID varchar(10), @LineNbr smallint, @Qty float As
Update ED850LDisc Set LineId = @NewLineId, Qty = @Qty, AllChgQuantity = @Qty Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
LineNbr = @LineNbr
GO
