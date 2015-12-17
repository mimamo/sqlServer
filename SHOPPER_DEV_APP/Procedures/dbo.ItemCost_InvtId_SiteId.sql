USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemCost_InvtId_SiteId] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar (25) as
        Select *
             from ItemCost
             where InvtId = @parm1
               and SiteId = @parm2
               and SpecificCostId Like @parm3
             order by InvtId, SiteId, SpecificCostId
GO
