USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_siteid_whseloc]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_siteid_whseloc    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_siteid_whseloc] @parm1 varchar(10), @parm2 varchar(10) As
    select * from LocTable
    where siteid = @parm1
    and whseloc like @parm2
    and LocTable.countstatus = 'A'
    order by siteid, whseloc
GO
