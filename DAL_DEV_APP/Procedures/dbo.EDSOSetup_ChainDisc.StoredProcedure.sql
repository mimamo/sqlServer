USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOSetup_ChainDisc]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOSetup_ChainDisc] As
Select ChainDiscEnabled From SOSetup
GO
