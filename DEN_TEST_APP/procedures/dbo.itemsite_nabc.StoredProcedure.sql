USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[itemsite_nabc]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.itemsite_nabc    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[itemsite_nabc] @parm1 Varchar(2), @parm2 VarChar(10) As
    select * from itemsite
    where abccode = @parm1
    and siteid = @parm2
    and itemsite.countstatus = 'A'
    order by siteid, invtid
GO
