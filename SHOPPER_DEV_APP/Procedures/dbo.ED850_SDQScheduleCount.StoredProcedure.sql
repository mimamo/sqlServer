USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_SDQScheduleCount]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850_SDQScheduleCount] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select Count(*) From ED850SDQ A Full Outer Join ED850Sched B On A.CpnyId = B.CpnyId And
A.EDIPOID = B.EDIPOID And A.LineId = B.LineId And A.StoreNbr = B.EntityId
Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID And A.LineId = @LineId
GO
