USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId2]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId2    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId2    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemCost_InvtId_SiteId2] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select * from ItemCost
                    where InvtId = @parm1
                    and SiteId = @parm2
                    order by InvtId, SiteId, RcptDate DESC, RcptNbr DESC
GO
