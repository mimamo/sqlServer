USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Sched_StdCartonCheck]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Sched_StdCartonCheck] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select A.LineId, A.Qty, A.UOM From ED850Sched A Inner Join ED850LineItem B On A.CpnyId = B.CpnyId And
A.EDIPOID = B.EDIPOID And A.LineId = B.LineId Inner Join InventoryADG C On B.InvtId = C.InvtId
Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID And C.PackMethod = 'SC'
GO
