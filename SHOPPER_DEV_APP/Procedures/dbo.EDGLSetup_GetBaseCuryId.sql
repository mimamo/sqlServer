USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGLSetup_GetBaseCuryId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGLSetup_GetBaseCuryId] As
Select BaseCuryId From GLSetup
GO
