USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ResetOK]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_ResetOK] @CpnyId varchar(10), @EDIPOID varchar(10) As
Update ED850Header Set UpdateStatus = 'OK' Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
