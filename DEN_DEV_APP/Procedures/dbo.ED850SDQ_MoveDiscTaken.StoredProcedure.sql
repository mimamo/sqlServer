USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_MoveDiscTaken]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_MoveDiscTaken] @CpnyId varchar(10), @EDIPOID varchar(10), @OldLineId int, @NewLineId int As
Update ED850SDQ Set LineId = @NewLineId Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId =
@OldLineId And DiscTaken = 1
GO
