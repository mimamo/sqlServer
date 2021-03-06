USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PricingHistory_All]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_PricingHistory_All]
	@CustID varchar(15),
	@InvtID varchar(30)
AS
	SELECT	SOLine.CurySlsPrice,
		SOHeader.CustID,
		SOLine.DiscPct,
		SOLine.DiscPrcType,
		SOLine.InvtID,
		SOHeader.OrdDate,
		SOLine.OrdNbr,
		SOLine.QtyOrd,
		SOLine.SlsPrice,
		SOLine.UnitDesc

	FROM	SOHeader

	JOIN	SOLine
	  ON 	SOLine.CpnyID = SOHeader.CpnyID
	 AND	SOLine.OrdNbr = SOHeader.OrdNbr

	WHERE	CustID = @CustID
	  AND 	InvtID = @InvtID

	ORDER BY OrdDate DESC

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
