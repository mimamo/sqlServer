USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_UpdateUOM]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_UpdateUOM] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @UOM varchar(6) As
Update ED850SDQ Set UOM = @UOM Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
