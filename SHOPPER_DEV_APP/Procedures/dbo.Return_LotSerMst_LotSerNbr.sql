USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Return_LotSerMst_LotSerNbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Return_LotSerMst_LotSerNbr]
	@parm1 varchar ( 30),
	@parm2 varchar (10),
	@parm3 varchar (10)
AS
    	SELECT * FROM VP_Return_AvailSerNbr
	WHERE InvtId = @parm1
              AND SiteId = @parm2
              AND WhseLoc = @parm3
              AND QtyAlloc < QtyOnHand
              ORDER BY InvtId, LotSerNbr
GO
