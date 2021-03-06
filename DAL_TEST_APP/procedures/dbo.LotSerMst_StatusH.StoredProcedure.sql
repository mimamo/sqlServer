USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_StatusH]    Script Date: 12/21/2015 13:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_StatusH    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerMst_StatusH    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerMst_StatusH] @parm1 varchar ( 30), @parm2 varchar (25), @parm3 varchar (10), @parm4 varchar (10) as
    Select * from LotSerMst where InvtId = @parm1
			and LotSerNbr = @parm2
                  and SiteId = @parm3
                  and WhseLoc like @parm4
                  and Status = 'H'
                  and QtyOnHand > 0
                  order by InvtId, SiteID, WhseLoc, LotSerNbr
GO
