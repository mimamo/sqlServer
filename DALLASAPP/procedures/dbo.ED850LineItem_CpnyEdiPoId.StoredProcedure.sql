USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_CpnyEdiPoId]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_CpnyEdiPoId] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850LineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Order by LineNbr
GO
