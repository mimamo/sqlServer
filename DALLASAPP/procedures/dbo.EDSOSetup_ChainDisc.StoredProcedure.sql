USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOSetup_ChainDisc]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOSetup_ChainDisc] As
Select ChainDiscEnabled From SOSetup
GO
