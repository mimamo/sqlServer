USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDGLSetup_GetBaseCuryId]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGLSetup_GetBaseCuryId] As
Select BaseCuryId From GLSetup
GO
