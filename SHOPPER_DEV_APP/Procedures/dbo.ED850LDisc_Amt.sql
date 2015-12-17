USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_Amt]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_Amt] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineQty float As
Select CuryTotAmt,SpecChgCode From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
LineId = @LineId And TotAmt > 0 And Indicator = 'A' And ((Pct = 0 And LDiscRate = 0) Or
(Qty Not In (0,@LineQty) Or AllChgQuantity Not In (0,@LineQty)))
GO
