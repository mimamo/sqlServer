USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_UpdateQty]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_UpdateQty] @NewQty float, @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineNbr smallint As
Update ED850SDQ Set Qty = @NewQty Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
And LineNbr = @LineNbr
GO
