USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_UpdateStatus]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_UpdateStatus] @CpnyId varchar(10), @EDIPOID varchar(10), @OrdNbr varchar(15) As
Update ED850Header Set UpdateStatus = 'OC', OrdNbr = @OrdNbr Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Update ED850HeaderExt Set ConvertedDate = GetDate() Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
