USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_QtyOrdered]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_QtyOrdered] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @ShipToId varchar(10) As
Select Case (Select Count(*) From SOHeader Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Cancelled = 0)
When 1 Then A.Qty Else B.Qty End From ED850LineItem A Left Outer Join ED850SDQ B On A.CpnyId =
B.CpnyId And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId Where A.CpnyId = @CpnyId And
A.EDIPOID = @EDIPOID And A.LineId = @LineId And (B.SolShipToId Is Null Or B.SolShipToId = @ShipToId)
GO
