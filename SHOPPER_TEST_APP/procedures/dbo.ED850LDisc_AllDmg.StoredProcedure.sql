USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_AllDmg]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LDisc_AllDmg] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID Order By CpnyId, EDIPOID, LineId
GO
