USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_KitChk]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SubLineItem_KitChk] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int
As
	Select InvtId, Qty, UOM
	From ED850SubLineItem
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		LineId = @LineId
GO
