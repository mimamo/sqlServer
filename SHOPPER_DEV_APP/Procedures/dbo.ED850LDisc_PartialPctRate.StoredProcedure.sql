USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_PartialPctRate]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_PartialPctRate] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineQty float As
Select Pct, LDiscRate, Qty, AllChgQuantity, SpecChgCode From ED850LDisc Where CpnyId = @CpnyId
And EDIPOID = @EDIPOId And LineId = @LineId And TotAmt = 0 And (Qty Not In (0, @LineQty) Or
AllChgQuantity Not In (0, @LineQty))
GO
