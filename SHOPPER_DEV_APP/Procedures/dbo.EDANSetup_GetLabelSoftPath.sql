USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_GetLabelSoftPath]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_GetLabelSoftPath] As
Select LabelSoftPath From ANSetup
GO
