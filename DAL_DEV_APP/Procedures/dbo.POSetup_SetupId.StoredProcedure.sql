USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POSetup_SetupId]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POSetup_SetupId    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POSetup_SetupId] @parm1 varchar ( 2) as
Select * from POSetup where SetupId like @parm1 order by SetupId
GO
