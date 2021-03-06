USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_CountLine]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SubLineItem_CountLine] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int
As
	Select Count(*)
	From ED850SubLineItem (NOLOCK)
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		LineId = @LineId
GO
