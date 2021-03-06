USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_SubLine]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_SubLine] @CpnyId varchar(10), @EDIPOID varchar(10) As
	Select A.LineId, A.InvtId, C.KitId
	From ED850LineItem A Left Outer Join Kit C On A.InvtId = C.KitId
	Where 	A.CpnyId = @CpnyId And
		A.EDIPOID = @EDIPOID And
		Exists (Select * From ED850SubLineItem B
			Where A.CpnyId = B.CpnyId And
				A.EDIPOID = B.EDIPOID And
				A.LineId = B.LineId)
GO
