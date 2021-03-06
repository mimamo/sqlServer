USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_ScheduleDisc]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_ScheduleDisc] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850SDQ A Full Outer Join ED850Sched B On A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId And A.StoreNbr = B.EntityId
Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID And A.LineId = @LineId Order By A.DiscTaken Desc, B.Date1 Desc
GO
