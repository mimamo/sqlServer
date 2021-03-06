USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_Delete]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850_Delete] @CpnyId varchar(10), @EDIPOID varchar(10) As
-- This procedure assumes that the ED850Header record will be deleted by the calling program.
Delete From ED850HeaderExt Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850LDesc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850LSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850LRef Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850MarkFor Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Delete From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
