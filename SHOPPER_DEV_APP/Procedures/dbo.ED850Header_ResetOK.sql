USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ResetOK]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_ResetOK] @CpnyId varchar(10), @EDIPOID varchar(10) As
Update ED850Header Set UpdateStatus = 'OK' Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
