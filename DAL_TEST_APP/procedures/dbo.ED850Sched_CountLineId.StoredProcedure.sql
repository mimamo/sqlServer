USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_CountLineId]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_CountLineId] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select Count(*) From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
