USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_InDataDir]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSetup_InDataDir] As
Select InDataDir From EDSetup
GO
