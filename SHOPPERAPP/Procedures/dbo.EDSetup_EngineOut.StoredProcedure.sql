USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_EngineOut]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_EngineOut] As
Select EngineOut From EDSetup
GO
