USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_Move]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Sched_Move] @CpnyId varchar(10), @EDIPOID varchar(10), @NewLineId int, @OldLineId int, @LineNbr smallint As
Update ED850Sched Set LineId = @NewLineId Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And
LineId = @OldLineId And LineNbr = @LineNbr
GO
