USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOSched_GetSDQShipTo]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOSched_GetSDQShipTo] @CpnyId varchar(10), @OrdNbr varchar(15), @LineRef varchar(5) As
Select Case A.MarkFor When 0 Then A.ShipToId Else B.MarkForId End From SOSched A Left Outer Join
SOSchedMark B On A.CpnyId = B.CpnyId And A.OrdNbr = B.OrdNbr And A.LineRef = B.LineRef And
A.SchedRef = B.SchedRef Where A.CpnyId = @CpnyId And A.OrdNbr = @OrdNbr And A.LineRef = @LineRef
GO
