USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_LineId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LDisc_LineId] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
GO
