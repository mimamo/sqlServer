USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_SDQ]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_SDQ] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select A.LineId,
	A.RequestDate,
	A.CancelDate,
	B.QTY,
	B.SolShipToId
From ED850LineItem A
	left outer join ED850SDQ B
		on A.CpnyId = B.CpnyId
		And A.EDIPOID = B.EDIPOID
		And A.LineId = B.LineId
Where A.CpnyId = @CpnyId
	And A.EDIPOID = @EDIPOID
GO
