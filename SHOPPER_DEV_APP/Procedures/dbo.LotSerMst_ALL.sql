USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_ALL]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_ALL    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerMst_ALL    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerMst_ALL] @parm1 varchar ( 30), @parm2 varchar (25) as
    Select * from LotSerMst where InvtId = @parm1
                  and LotSerNbr = @parm2
                  order by InvtId, Siteid, Whseloc, LotSerNbr
GO
