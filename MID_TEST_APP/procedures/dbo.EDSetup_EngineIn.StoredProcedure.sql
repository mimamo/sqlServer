USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_EngineIn]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_EngineIn] As
Select EngineIn From EDSetup
GO
