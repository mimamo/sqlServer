USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TermsDet_TermsID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TermsDet_TermsID    Script Date: 4/7/98 12:42:26 PM ******/
Create Procedure [dbo].[TermsDet_TermsID]
@parm1 varchar (2) as
Select * from TermsDet where TermsID = @parm1
Order by TermsID, InstallNbr
GO
