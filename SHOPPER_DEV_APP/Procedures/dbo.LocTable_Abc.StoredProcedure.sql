USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_Abc]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_Abc    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_Abc] @parm1 VarChar(10) as
    update LocTable set LocTable.selected = 1, countstatus = 'P'
    From LocTable, PIAbc
    where LocTable.siteid = @parm1
    and LocTable.countstatus = 'A'
    and LocTable.abccode = piabc.abccode
    and LocTable.lastvarpct > (100 - piabc.tolerance)
GO
