USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_MoveSDQ]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Sched_MoveSDQ] @CpnyId varchar(10), @EDIPOID varchar(10), @OldLineId int, @NewLineId int As
Update ED850Sched Set LineId = @NewLineId From ED850Sched A Inner Join ED850SDQ B On A.CpnyId = B.CpnyId
And A.EDIPOID = B.EDIPOID And A.EntityId = B.StoreNbr Where A.LineId = @OldLineId And
B.LineId = @NewLineId And A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
GO
