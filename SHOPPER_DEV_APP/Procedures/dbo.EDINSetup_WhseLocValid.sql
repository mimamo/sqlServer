USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDINSetup_WhseLocValid]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDINSetup_WhseLocValid] As
Select WhseLocValid From INSetup
GO
