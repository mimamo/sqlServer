USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_Inquiry]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_Inquiry    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerMst_Inquiry    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerMst_Inquiry] @parm1 varchar ( 30), @parm2 varchar (10), @parm3 varchar (10) as
    Select * from LotSerMst where InvtId = @parm1
                  and SiteId = @parm2
                  and WhseLoc like @parm3
                  and status = 'A'
                  and QtyOnHand <> 0
                  order by InvtId, SiteID, WhseLoc, LotSerNbr
GO
