USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_Cycle]    Script Date: 12/21/2015 14:17:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_Cycle    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[LocTable_Cycle] @parm1 VarChar(10), @parm2 Varchar(10) as
    update LocTable set selected = 1, countstatus = 'P'
    where siteid = @parm1
    and countstatus = 'A'
    and cycleid = @parm2
GO
