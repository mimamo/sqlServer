USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_InvtId]    Script Date: 12/21/2015 16:07:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_InvtId    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[ItemSite_InvtId] @parm1 varchar ( 30) as
        Select * from ItemSite where InvtId = @parm1
                    order by InvtId, SiteId
GO
