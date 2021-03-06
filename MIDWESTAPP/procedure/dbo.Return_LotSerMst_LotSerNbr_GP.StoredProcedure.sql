USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Return_LotSerMst_LotSerNbr_GP]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Return_LotSerMst_LotSerNbr_GP]
	@parm1 varchar ( 30),
	@parm2 varchar (10),
	@parm3 varchar (10),
	@parm4 varchar (10)
AS
    SELECT * FROM VP_Return_AvailSerNbr_GP
	WHERE InvtId = @parm1
              AND SiteId = @parm2
              AND WhseLoc = @parm3
              AND SrcOrdNbr = @parm4
	ORDER BY InvtId, LotSerNbr
GO
