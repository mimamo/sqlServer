USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetup_SetupId]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLSetup_SetupId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLSetup_SetupId] @parm1 varchar ( 2) as
       Select * from GLSetup
           where SetupId like @parm1
           order by SetupId
GO
