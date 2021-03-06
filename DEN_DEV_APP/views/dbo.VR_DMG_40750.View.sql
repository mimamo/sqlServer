USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[VR_DMG_40750]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VR_DMG_40750]

 AS

--SOShipLineSplit 	s
--SOShipHeader 		h
--ARDoc			d
--ARTran		t

select 	
	s.CpnyID, s.CreditPct, s.SlsperID, s.LineRef,
	h.DiscPct, 
	d.PerClosed, d.OrigDocAmt, 
	t.CustId, t.DrCr, t.ExtCost, t.InvtId, t.ShipperLineRef, t.Qty, t.RefNbr, 
	Disc = Sum(Coalesce(ARTranDisc.TranAmt, 0)), 
	OrderDisc =   ((t.TranAmt - Sum(Coalesce(ARTranDisc.TranAmt, 0))) * (h.DiscPct /100)),
	TranAmt = (t.TranAmt - Sum(Coalesce(ARTranDisc.TranAmt, 0))),
	t.TranClass, t.TranDate, t.TranType, t.UnitDesc, t.UnitPrice, t.PerPost, t.Rlsed
from 
SOShipLineSplit s
	     INNER JOIN SOShipHeader h ON
	        s.CpnyID = h.CpnyID AND
	    	s.ShipperID = h.ShipperID
	     INNER JOIN ARDoc d ON
	        h.CpnyID = d.CpnyID AND
	    	h.CustID = d.CustId AND
	    	h.InvcNbr = d.RefNbr AND
		d.DocClass = 'N'
	     INNER JOIN ARTran t ON
	        d.CpnyID = t.CpnyID AND
	     	d.CustId = t.CustId AND
	    	s.LineRef = t.ShipperLineRef AND
	    	d.RefNbr = t.RefNbr AND
		t.TranClass = 'N'
	    LEFT OUTER JOIN ARTran ARTranDisc ON
	        d.CpnyID = ARTranDisc.CpnyID AND
	    	d.CustId = ARTranDisc.CustId AND
	    	s.LineRef = ARTranDisc.ShipperLineRef AND
	    	d.RefNbr = ARTranDisc.RefNbr AND
	    	ARTranDisc.TranClass = 'D'
	GROUP BY s.CpnyID, s.CreditPct, s.SlsperID, s.LineRef,
			h.DiscPct, 
			d.PerClosed, d.OrigDocAmt, 
			t.CustId, t.DrCr, t.ExtCost, t.InvtId, t.ShipperLineRef, t.Qty, t.RefNbr, 
			t.TranClass, t.TranDate, t.TranType, t.UnitDesc, t.UnitPrice, 
			t.PerPost, t.Rlsed, t.TranAmt
GO
