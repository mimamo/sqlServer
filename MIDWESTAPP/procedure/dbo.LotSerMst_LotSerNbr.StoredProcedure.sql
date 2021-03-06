USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_LotSerNbr]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_LotSerNbr    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerMst_LotSerNbr] @parm1 varchar ( 30), @parm2 varchar (10) , @parm3 varchar (10) as
    Select * from LotSerMst where InvtId = @parm1
                  and SiteId = @parm2
                  and WhseLoc = @parm3
                  and Status = 'A'
	          and QtyAlloc < QtyOnHand
                  order by InvtId, LotSerNbr
GO
