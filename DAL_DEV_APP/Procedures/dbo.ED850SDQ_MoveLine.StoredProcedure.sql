USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_MoveLine]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_MoveLine] @NewLineId int, @CpnyId varchar(10), @EDIPOID varchar(10), @LineNbr smallint As
Update ED850Sched Set LineId = @NewLineId Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
And LineNbr = @LineNbr
GO
