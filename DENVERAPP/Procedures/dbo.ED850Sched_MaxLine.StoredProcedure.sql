USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_MaxLine]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_MaxLine] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Max(LineId), Max(LineNbr) From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
