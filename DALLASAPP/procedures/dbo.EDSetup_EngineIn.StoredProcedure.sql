USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_EngineIn]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_EngineIn] As
Select EngineIn From EDSetup
GO
