USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LSSS_LineItem]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LSSS_LineItem] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Order By CpnyId, EDIPOID, LineId, LineNbr
GO
