USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[itemsite_siteid_invtid]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.itemsite_siteid_invtid    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[itemsite_siteid_invtid] @parm1 varchar(10), @parm2 varchar(30) As
    select * from itemsite where siteid = @parm1
    and invtid like @parm2
    and itemsite.countstatus = 'A'
    order by invtid, siteid
GO
