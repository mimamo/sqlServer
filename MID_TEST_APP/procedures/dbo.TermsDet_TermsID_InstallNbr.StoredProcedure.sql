USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TermsDet_TermsID_InstallNbr]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TermsDet_TermsID_InstallNbr    Script Date: 4/7/98 12:42:26 PM ******/
Create Procedure [dbo].[TermsDet_TermsID_InstallNbr]
@parm1 varchar (2), @parm2beg smallint, @parm2end smallint as
Select * from TermsDet where TermsID = @parm1 and InstallNbr Between @parm2beg and @parm2end
Order by TermsID, InstallNbr
GO
