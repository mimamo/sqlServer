USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DDSetup_SetupID]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDSetup_SetupID] @parm1 varchar ( 2) as
    Select * from DDSetup where SetupID LIKE @parm1 ORDER by SetupId
GO
