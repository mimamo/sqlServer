USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_CountLineIdEntityId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_CountLineIdEntityId] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @EntityId varchar(80)
As
	Select Count(*)
	From ED850Sched
	Where 	CpnyId = @CpnyId And
		EDIPOID = @EDIPOID And
		LineId = @LineId And
		EntityId Like @EntityId
GO
