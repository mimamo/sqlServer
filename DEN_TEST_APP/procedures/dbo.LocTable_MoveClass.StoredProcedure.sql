USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_MoveClass]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_MoveClass    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_MoveClass] @parm1 VarChar(10) as
    update LocTable set LocTable.selected = 1, countstatus = 'P'
    From LocTable, PIMovecl
    where LocTable.siteid = @parm1
    and LocTable.countstatus = 'A'
    and LocTable.moveclass = pimovecl.moveclass
    and LocTable.lastvarpct > (100 - pimovecl.tolerance)
GO
