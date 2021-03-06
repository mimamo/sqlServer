USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Return_Vp_LotSerMst_LotSerNbr]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Return_Vp_LotSerMst_LotSerNbr]
	@parm1 varchar ( 30),
	@parm2 varchar (10),
	@parm3 varchar (10),
	@parm4 varchar (25)
AS
    	SELECT * FROM VP_Return_AvailSerNbr
	WHERE InvtId = @parm1
              AND SiteId = @parm2
              AND WhseLoc = @parm3
              AND LotSerNbr = @parm4
              ORDER BY InvtId, SiteID,WhseLoc, LotSerNbr
GO
