USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_LineIdEntityId]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_LineIdEntityId] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @EntityId varchar(80)
As
	Select * From ED850Sched
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		LineId = @LineId And
		EntityId Like @EntityId
GO
