USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_UpdateQty]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_UpdateQty] @NewQty float, @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineNbr smallint As
Update ED850SDQ Set Qty = @NewQty Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
And LineNbr = @LineNbr
GO
