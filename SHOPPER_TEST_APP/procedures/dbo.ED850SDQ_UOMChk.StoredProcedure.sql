USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_UOMChk]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_UOMChk] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select A.LineId From ED850SDQ A Inner Join ED850LineItem B On A.CpnyId = B.CpnyId And A.EDIPOID =
B.EDIPOID And A.LineId = B.LineId Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID And
A.UOM <> B.UOM
GO
