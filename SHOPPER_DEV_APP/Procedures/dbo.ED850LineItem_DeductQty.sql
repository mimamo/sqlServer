USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_DeductQty]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_DeductQty] @DeductQty float, @CpnyId varchar(10), @EDIPOID varchar(10), @LineNbr smallint As
Update ED850LineItem Set Qty = Qty - @DeductQty Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
LineNbr = @LineNbr
GO
