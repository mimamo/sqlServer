USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XS_ReportPrivacy_Rpt_Fmt]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XS_ReportPrivacy_Rpt_Fmt] 
 @parm1 VarChar( 5 ),
 @parm2 VarChar( 30 )
As
 Select * from XS_ReportPrivacy where ReportNbr = @parm1 and
 ReportFormat in (@parm2, '<ALL>')
 Order by ReportNbr, ReportFormat desc
GO
