USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TermsDet_DEL_TermsID]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TermsDet_DEL_TermsID    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[TermsDet_DEL_TermsID] @parm1 varchar (2) As
     Delete from TermsDet
     Where TermsID = @parm1
GO
