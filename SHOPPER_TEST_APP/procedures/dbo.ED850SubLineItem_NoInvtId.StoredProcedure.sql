USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_NoInvtId]    Script Date: 12/21/2015 16:07:04 ******/
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
