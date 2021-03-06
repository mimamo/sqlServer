USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_FreeFormQtyCheck]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SDQ_FreeFormQtyCheck] @CpnyId varchar(10), @EDIPOID varchar(10)
As
	Select LineId From ED850SDQ
	Where Exists (Select * From ED850SubLineItem
			Where 	ED850SubLineItem.CpnyId = @CpnyId And
				ED850SubLineItem.EDIPOID = @EDIPOID And
				ED850SubLineItem.LineId = ED850SDQ.LineId) And
		CpnyId = @CpnyId And
		EDIPOID = @EDIPOID
	Group By LineId Having Sum(Qty) <> (Select Qty From ED850LineItem
						Where 	ED850LineItem.CpnyId = @CpnyId And
							ED850LineItem.EDIPOID = @EDIPOID And
							ED850LineItem.LineId = ED850SDQ.LineId)
GO
