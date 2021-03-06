USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_Price]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_Price] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select A.Qty, A.Price, A.UOM, B.InvtId, A.LineId, B.StkUnit, B.ClassId, B.StkBasePrc From ED850LineItem A, Inventory B
Where A.InvtId = B.InvtId And A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID Order By A.LineId
GO
