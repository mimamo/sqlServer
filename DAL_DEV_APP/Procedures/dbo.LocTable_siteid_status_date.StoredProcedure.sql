USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_siteid_status_date]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_siteid_status_date    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_siteid_status_date] @parm1 varchar(10), @parm2 varchar(1), @parm3 smalldatetime As
    select whseloc, selected, cycleid from LocTable
    where siteid = @parm1
    and countstatus = @parm2
    and lastcountdate <= @parm3

    order by siteid, whseloc
GO
