USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_LineItem]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_LineItem] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Lineid = @LineId
Order By CpnyId, EDIPOID, LineId,LineNbr
GO
