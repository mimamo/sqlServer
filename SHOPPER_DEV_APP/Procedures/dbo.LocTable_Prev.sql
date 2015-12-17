USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_Prev]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_Prev    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_Prev] @parm1 VarChar(10), @parm2 VarChar(10) as
    update LocTable set LocTable.selected = 1, LocTable.Countstatus = 'P'
    From Loctable, PIdetail
    where pidetail.piid = @parm1
    and LocTable.siteid = @parm2
    and LocTable.countstatus = 'A'
    and LocTable.whseloc = pidetail.whseloc
    and LocTable.siteid = pidetail.siteid
GO
