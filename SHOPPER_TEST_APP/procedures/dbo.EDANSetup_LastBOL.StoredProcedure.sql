USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_LastBOL]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_LastBOL] As
Select Left(LastBOL,10) From ANSetup
GO
