USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerNbr_Return_GP_PV]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerNbr_Return_GP_PV] 
	@parm1 varchar (30),
	@parm2 varchar (10),
	@parm3 varchar (10),
	@parm4 varchar (10),
	@parm5 varchar (25)
AS
    Select * from LotSerMst
	where InvtId = @parm1
	  and SiteId = @parm2
	  and WhseLoc = @parm3
	  and SrcOrdNbr = @parm4
	  and lotsernbr like @parm5
	  order by InvtId, SiteID, WhseLoc, LotSerNbr
GO
