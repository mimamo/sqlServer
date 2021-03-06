USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850ValidateSDQQty]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850ValidateSDQQty] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select B.LineId From ED850SDQ A, ED850LineItem B Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
And A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId Group By B.LineId
Having Sum(A.Qty) <> Avg(B.Qty) Order By B.LineId
GO
