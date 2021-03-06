USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_WholeLine]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LDisc_WholeLine] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int, @LineQty Float As
Select * From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
And AllChgQuantity In (0,@LineQty) And Qty In (0,@LineQty) And (LDiscRate > 0 Or Pct > 0) And
TotAmt = 0 And Indicator = 'A'
GO
