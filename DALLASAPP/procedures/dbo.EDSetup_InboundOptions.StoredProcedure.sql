USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_InboundOptions]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_InboundOptions] As
Select InDataDir, InTranslatorVerify From EDSetup
GO
