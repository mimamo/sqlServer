USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_LastBOL]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_LastBOL] As
Select Left(LastBOL,10) From ANSetup
GO
