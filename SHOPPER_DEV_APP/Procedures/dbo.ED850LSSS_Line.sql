USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LSSS_Line]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LSSS_Line] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
