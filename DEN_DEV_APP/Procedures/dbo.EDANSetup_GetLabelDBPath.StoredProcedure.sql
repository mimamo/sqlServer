USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_GetLabelDBPath]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_GetLabelDBPath] As
Select LabelDBPath From ANSetup
GO
