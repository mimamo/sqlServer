USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Prev]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Prev    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[ItemSite_Prev] @parm1 VarChar(10), @parm2 varChar(10) as
    update itemsite set itemsite.selected = 1, itemsite.countstatus = 'P'
    From itemsite, pidetail
    where pidetail.piid = @parm1
    and itemsite.siteid = @parm2
    and itemsite.countstatus = 'A'
    and itemsite.invtid = pidetail.invtid
    and itemsite.siteid = pidetail.siteid
GO
