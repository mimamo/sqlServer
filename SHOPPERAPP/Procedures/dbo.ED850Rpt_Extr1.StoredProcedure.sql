USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Rpt_Extr1]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Rpt_Extr1] @FromDate datetime, @ToDate datetime AS
select b.CpnyID, b.EDIPoID, b.Invtid,  b.LineID,
	c.descr, b.CuryPrice, b.qty, b.sku,
	b.uom, b.upc, a.creationdate, a.CancelDate,
	a.ConvertedDate, a.PODate, a.ArrivalDate, a.DeliveryDate,
	a.RequestDate, a.ScheduleDate, a.ShipDate, a.ShipNBDate, a.ShipNLDate
from ED850HeaderExt a, ED850LineItem b
	left outer join inventory c
		on b.invtid = c.invtid
where creationdate between @FromDate and @ToDate and
a.CpnyID = b.CpnyID and
a.EDIPOId = b.edipoid
Order By B.CpnyId, B.EDIPOID, B.LineId
GO
