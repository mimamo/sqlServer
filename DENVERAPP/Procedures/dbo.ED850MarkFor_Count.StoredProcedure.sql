USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850MarkFor_Count]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850MarkFor_Count] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Count(*) From ED850MarkFor Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
