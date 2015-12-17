USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_LineItem]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_LineItem] @CpnyId varchar(10), @EDIPOID varchar(10), @Lineid int As
Select * From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Order By CpnyId, EDIPOID, LineId, LineNbr
GO
