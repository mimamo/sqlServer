USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_ByLineId]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_ByLineId] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850LineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID Order By LineId
GO
