USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XS_ReportPrivacy_ReportNbr]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XS_ReportPrivacy_ReportNbr] @parm1 Varchar(5) As
Select * from vs_RptControl, vs_Screen
Where ReportNbr like @parm1 and ReportNbr = left(vs_screen.Name,5) and ScreenType = 'R'
GO
