USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_810]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSetup_810] As
Select InvcTranControl, TranOutput, InvcRunUserEXE, InvcUserEXE, InvcRecheck From EDSetup
GO
