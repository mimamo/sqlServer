USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_UpdateQty]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_UpdateQty] @NewQty float, @CpnyId varchar(10), @EDIPOID varchar(10), @LineNbr smallint As
Update ED850Sched Set Qty = @NewQty Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineNbr = @LineNbr
GO
