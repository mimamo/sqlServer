USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[ED850Head2Line]    Script Date: 12/21/2015 15:55:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[ED850Head2Line]
AS
SELECT a.CpnyID, a.EDIPOID, a.OrdNbr, b.InvtID, b.LineRef, 
    b.DiscPct, b.QtyOrd, b.SlsPrice, b.Descr, b.QtyShip, b.TotCost, 
    b.TotOrd
FROM SOHeader a, SOLine b
WHERE a.CpnyID = b.CpnyID AND a.OrdNbr = b.OrdNbr AND 
    a.Cancelled = 0
GO
