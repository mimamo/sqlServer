USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[itemsite_siteid_status]    Script Date: 12/21/2015 16:07:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.itemsite_siteid_status    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[itemsite_siteid_status] @parm1 varchar(10), @parm2 varchar(1)  As
    select invtid, selected, cycleid from itemsite
    where siteid = @parm1
    and countstatus = @parm2
    order by  invtid
GO
