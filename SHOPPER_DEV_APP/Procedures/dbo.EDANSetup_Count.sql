USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_Count]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDANSetup_Count] As
Select Count(*) From ANSetup
GO
