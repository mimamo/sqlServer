USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Rpt_Extr1OK]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Rpt_Extr1OK] @FromDate datetime, @ToDate datetime AS
select b.CpnyID, b.EDIPoID, b.Invtid,  b.LineID,
	c.descr, b.CuryPrice, b.qty, b.sku,
	b.uom, b.upc, a.creationdate, a.CancelDate,
	a.ConvertedDate, a.PODate, a.ArrivalDate, a.DeliveryDate,
	a.RequestDate, a.ScheduleDate, a.ShipDate, a.ShipNBDate, a.ShipNLDate
from ED850HeaderExt a, ED850LineItem b
		left outer join inventory c
			on 	b.invtid = c.invtid
	, ED850Header d
where creationdate between @FromDate and @ToDate and
	a.CpnyID = b.CpnyID and
	a.CpnyID = d.CpnyID and
	a.EDIPOId = b.edipoid and
	a.EDIPOId = d.EDIPOId and
	d.UpdateStatus not in ('OK', 'OC')
Order By B.CpnyId, B.EDIPOID, B.LineId
GO
