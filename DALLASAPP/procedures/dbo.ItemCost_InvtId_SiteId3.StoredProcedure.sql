USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId3]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId3    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemCost_InvtId_SiteId3    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemCost_InvtId_SiteId3]
		@parm1 varchar ( 30),
		@parm2 varchar ( 10),
		@parm3 varchar ( 25),
		@parm4 varchar ( 15)
as
        Select * from ItemCost
                    where InvtId = @parm1
                    and SiteId = @parm2
			  and (SpecificCostId = @parm3 or SpecificCostID Is Null)
                    and RcptNbr like @parm4
                    order by InvtId, SiteId, SpecificCostId, RcptNbr
GO
