USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARSetup_SetupId]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARSetup_SetupId    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARSetup_SetupId] @parm1 varchar ( 2) as
    Select * from ARSetup where setupid like @parm1 order by SetupId
GO
