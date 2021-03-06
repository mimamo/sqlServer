USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HDisc_PctAmt]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850HDisc_PctAmt] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850HDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Indicator = 'A'
And (Pct <> 0 Or HDiscRate <> 0 Or TotAmt <> 0)
Order By Case When Pct <> 0 Or HDiscRate <> 0 Then 0 Else 1 End
GO
