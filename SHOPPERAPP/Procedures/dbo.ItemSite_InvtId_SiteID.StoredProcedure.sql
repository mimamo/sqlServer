USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_InvtId_SiteID]    Script Date: 12/21/2015 16:13:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_InvtId_SiteID    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemSite_InvtId_SiteID    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemSite_InvtId_SiteID] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select * from ItemSite where InvtId = @parm1
			  and  SiteId = @parm2
                    order by InvtId, SiteId
GO
