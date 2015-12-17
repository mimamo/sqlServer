USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtId_SiteId_Whse]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerMst_InvtId_SiteId_Whse] @parm1 varchar ( 24), @parm2 varchar ( 10), @parm3 varchar ( 10) as
        Select * from LotSerMst where InvtId = @parm1
                                and  SiteId = @parm2
                                and Whseloc Like @parm3
            order by InvtId, SiteId, LotSerNbr, WhseLoc
GO
