USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDINSetup_WhseLocValid]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDINSetup_WhseLocValid] As
Select WhseLocValid From INSetup
GO
