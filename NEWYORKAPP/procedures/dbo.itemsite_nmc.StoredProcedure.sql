USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[itemsite_nmc]    Script Date: 12/21/2015 16:01:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.itemsite_nmc    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[itemsite_nmc] @parm1 Varchar(10), @parm2 varchar(10) As
    select * from itemsite
    where moveclass = @parm1
    and siteid = @parm2
    and itemsite.countstatus = 'A'
    order by siteid, invtid
GO
