USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XS_ReportPrivacy_ReportNbr]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XS_ReportPrivacy_ReportNbr] @parm1 Varchar(5) As
Select * from vs_RptControl, vs_Screen
Where ReportNbr like @parm1 and ReportNbr = left(vs_screen.Name,5) and ScreenType = 'R'
GO
