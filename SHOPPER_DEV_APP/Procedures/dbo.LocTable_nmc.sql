USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_nmc]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_nmc    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[LocTable_nmc] @parm1 Varchar(10), @parm2 Varchar(10) As
    select * from LocTable
    where moveclass = @parm1
    and siteid = @parm2
    and LocTable.countstatus = 'A'
    order by siteid, whseloc
GO
