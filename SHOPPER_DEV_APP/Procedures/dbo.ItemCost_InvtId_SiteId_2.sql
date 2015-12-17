USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId_2]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId_2    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId_2    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemCost_InvtId_SiteId_2]
		@parm1 varchar ( 30),
		@parm2 varchar ( 10),
		@parm3 varchar ( 15),
		@parm4 smalldatetime
as
        Select * from ItemCost
                    where InvtId = @parm1
                    and SiteId = @parm2
                    and RcptNbr = @parm3
                    and RcptDate = @parm4
                    order by InvtId, SiteId, RcptDate, RcptNbr
GO
