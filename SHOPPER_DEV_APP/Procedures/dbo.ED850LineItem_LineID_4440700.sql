USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_LineID_4440700]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ED850LineItem_LineID_4440700] @CpnyId varchar(10), @EDIPOID varchar(10), @LineID integer
As
	SELECT * FROM ED850LineItem
	WHERE CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineID = @LineID
GO
