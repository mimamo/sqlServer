USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_InboundOptions]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_InboundOptions] As
Select InDataDir, InTranslatorVerify From EDSetup
GO
