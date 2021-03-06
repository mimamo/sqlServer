USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Return_LotSerMst_LotSerNbr_LIFODate]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Return_LotSerMst_LotSerNbr_LIFODate]
	@parm1 varchar ( 30),
	@parm2 varchar (10),
	@parm3 varchar (10)
AS
    	SELECT * FROM VP_Return_AvailSerNbr
	WHERE InvtId = @parm1
              AND SiteId = @parm2
              AND WhseLoc = @parm3
              ORDER BY InvtId, LIFOdate desc, LotSerNbr desc
GO
