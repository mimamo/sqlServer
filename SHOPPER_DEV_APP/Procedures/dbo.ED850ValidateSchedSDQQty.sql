USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850ValidateSchedSDQQty]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850ValidateSchedSDQQty] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select A.LineId From ED850Sched A Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Group By A.CpnyId,A.EDIPOID,A.LineId Having Sum(Qty) <> (Select Sum(Qty) From ED850SDQ B Where A.CpnyId = B.CpnyId
And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId)
GO
