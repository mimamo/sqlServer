USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APSetup_SetupId]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APSetup_SetupId    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APSetup_SetupId] @parm1 varchar ( 2) as
Select * from APSetup where SetupId like @parm1 order by SetupId
GO
