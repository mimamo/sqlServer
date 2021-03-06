USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerNbr_Return_PV]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LotSerNbr_Return_PV]
	@parm1 varchar ( 30),
	@parm2 varchar (10),
	@parm3 varchar (10),
	@parm4 varchar (25)
AS
SELECT *  FROM LotSerMst
           WHERE InvtID = @parm1
           AND SiteId = @parm2
           AND WhseLoc = @parm3
	   AND lotsernbr like @Parm4
           AND QtyonHand = 0
           AND Status = 'A'
           ORDER BY InvtId, SiteID, WhseLoc, LotSerNbr
GO
