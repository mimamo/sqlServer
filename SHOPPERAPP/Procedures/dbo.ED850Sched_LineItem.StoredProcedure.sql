USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_LineItem]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_LineItem] @CpnyId varchar(10), @EDIPOID varchar(10), @Lineid int As
Select * From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Order By CpnyId, EDIPOID, LineId, LineNbr
GO
