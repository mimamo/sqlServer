USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_GetLabelSoftPath]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_GetLabelSoftPath] As
Select LabelSoftPath From ANSetup
GO
