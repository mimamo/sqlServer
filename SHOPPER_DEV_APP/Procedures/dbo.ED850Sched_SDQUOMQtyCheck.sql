USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_SDQUOMQtyCheck]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Sched_SDQUOMQtyCheck] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Distinct A.LineId From ED850Sched A Inner Join ED850SDQ B On
A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId And A.EntityId = B.StoreNbr Where
A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID Group By A.LineId, A.EntityId Having Sum(A.Qty) <> Sum(B.Qty) Or
Count(Distinct A.UOM) <> Count(Distinct B.UOM) Or Min(A.UOM) <> Min(B.UOM)
GO
