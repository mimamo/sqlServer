USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Abc]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Abc    Script Date: 4/17/98 10:58:17 AM ******/
Create Procedure [dbo].[ItemSite_Abc] @parm1 Varchar(10) as
    update itemsite set itemsite.selected = 1, countstatus = 'P'
    from itemsite, piabc
    where itemsite.siteid = @parm1
    and itemsite.countstatus = 'A'
    and itemsite.abccode = piabc.abccode
    and itemsite.lastvarpct > (100 - piabc.tolerance)
GO
