USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOSetup_ChainDisc]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOSetup_ChainDisc] As
Select ChainDiscEnabled From SOSetup
GO
