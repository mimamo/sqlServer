USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_DiscLines]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_DiscLines] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850LineItem A, ED850LDisc B Where A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID
And A.LineId = B.LineId And A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
And B.Qty + B.AllChgQuantity > 0 And  (A.Qty <> B.AllChgQuantity Or A.Qty <> B.Qty) And
(B.LDiscRate > 0 Or B.Pct > 0)
GO
