USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_NoInvtId]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SubLineItem_NoInvtId] @CpnyId varchar(10), @EDIPOID varchar(10)
As
	Select * From ED850SubLineItem
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		InvtId = ''
GO
