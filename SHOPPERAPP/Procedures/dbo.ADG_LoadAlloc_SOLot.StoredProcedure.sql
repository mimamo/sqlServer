USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_SOLot]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_SOLot]
	@CpnyID		Varchar(10),
	@OrdNbr		Varchar(15)
As

SELECT	SOLot.LineRef, SOLine.InvtID, SOLine.SiteID, SOLot.WhseLoc, SOLot.LotSerNbr,
	SOLot.QtyShip, SOLine.CnvFact, SOLine.UnitMultDiv
	FROM	SOLine (NOLOCK)
	JOIN	SOLot (NOLOCK)
	ON	SOLine.CpnyID = SOLot.CpnyID
	AND	SOLine.OrdNbr = SOLot.OrdNbr
	AND	SOLine.LineRef = SOLot.LineRef
	WHERE	SOLine.CpnyID = @CpnyID
		AND SOLine.OrdNbr = @OrdNbr
		AND SOLine.Status = 'O'
		AND SOLot.Status = 'O'
		AND SOLot.QtyShip > 0
GO
