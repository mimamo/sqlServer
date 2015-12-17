USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_DiscCheck]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SubLineItem_DiscCheck] @CpnyId varchar(10), @EDIPOID varchar(10)
As
	Select LineId
	From ED850SubLineItem
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		Exists (Select * From ED850LDisc
			Where 	ED850LDisc.CpnyId = ED850SubLineItem.CpnyId And
				ED850LDisc.EDIPOID = ED850SubLineItem.EDIPOID And
				ED850LDisc.LineId = ED850SubLineItem.LineId)
GO
