USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_ByLineId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_ByLineId] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850LineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID Order By LineId
GO
