USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_LineItem]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDesc_LineItem] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Select * From ED850LDesc Where CpnyId = @CpnyId And EDIPOID= @EDIPOID And Lineid = @LineId
Order By CpnyId, EDIPOID, LineId, LineNbr
GO
