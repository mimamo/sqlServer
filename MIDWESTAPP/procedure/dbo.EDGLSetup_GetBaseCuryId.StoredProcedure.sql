USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDGLSetup_GetBaseCuryId]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGLSetup_GetBaseCuryId] As
Select BaseCuryId From GLSetup
GO
