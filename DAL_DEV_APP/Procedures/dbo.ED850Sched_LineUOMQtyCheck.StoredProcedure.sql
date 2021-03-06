USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_LineUOMQtyCheck]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Sched_LineUOMQtyCheck] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Distinct A.LineId From ED850Sched A Inner Join ED850LineItem B On
A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId Where
A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID Group By A.LineId Having Sum(A.Qty) <> Max(B.Qty) Or
Min(A.UOM) <> Max(A.UOM) Or Min(A.UOM) <> Min(B.UOM)
GO
