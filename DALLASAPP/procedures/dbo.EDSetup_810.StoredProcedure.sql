USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_810]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSetup_810] As
Select InvcTranControl, TranOutput, InvcRunUserEXE, InvcUserEXE, InvcRecheck From EDSetup
GO
