USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_ItemSite_Reset]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetail_ItemSite_Reset    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[PIDetail_ItemSite_Reset] @parm1 VarChar(10) as
    Update itemsite set itemsite.countstatus = 'A'
    From itemsite, pidetail
    Where pidetail.piid = @parm1
    and itemsite.countstatus = 'P'
    and itemsite.siteid = pidetail.siteid
    and itemsite.invtid = pidetail.invtid
GO
