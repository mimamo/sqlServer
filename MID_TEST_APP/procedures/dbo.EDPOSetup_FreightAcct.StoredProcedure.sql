USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPOSetup_FreightAcct]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPOSetup_FreightAcct] As
Select S4Future11, S4Future01 From POSetup
GO
