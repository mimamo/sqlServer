USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtId_SiteId_PVW]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerMst_InvtId_SiteId_PVW] @parm1 varchar ( 24), @parm2 varchar ( 10), @parm3 varchar ( 15), @parm4 varchar ( 10) as
        Select * from LotSerMst where InvtId = @parm1
                                and  SiteId = @parm2
                                and LotSerNbr = @parm3
                                and Whseloc Like @parm4
            order by InvtId, SiteId, LotSerNbr, WhseLoc
GO
