USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HDisc_DiscAmt]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850HDisc_DiscAmt] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Sum(CuryTotAmt) From ED850HDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Indicator = 'A' And TotAmt > 0  And HDiscRate = 0 And Pct = 0
GO
