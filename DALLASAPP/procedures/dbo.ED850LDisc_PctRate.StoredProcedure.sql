USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_PctRate]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_PctRate] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineQty float As
Select Pct, LDiscRate, SpecChgCode From ED850LDisc A Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
LineId = @LineId And (LDiscRate > 0 Or Pct > 0) And Indicator = 'A'  And Qty In (0, @LineQty) And
AllChgQuantity In (0, @LineQty)
GO
