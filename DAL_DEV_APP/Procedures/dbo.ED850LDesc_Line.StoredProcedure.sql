USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_Line]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LDesc_Line] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LDesc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
