USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SOLine_ClearPO]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SOLine_ClearPO] @CpnyId varchar(10), @EDIPOID varchar(10)
As
	Delete From ED850SOLine
	Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
