USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_Line]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SubLineItem_Line] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int
As
	Select * From ED850SubLineItem
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		LineId = @LineId
	Order By CpnyId, EDIPOID, LineId, LineNbr
GO
