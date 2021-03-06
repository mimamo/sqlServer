USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Rpt_Extr2]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Rpt_Extr2] @CpnyID varchar(10), @EDIPOId varchar(10), @InvtID varchar(30) AS
select a.EDIPOID, a.CpnyID, a.OrdNbr, b.invtid, sum(b.QtyOrd) 'QtyOrd', sum(b.CurySlsPrice) 'SlsPrice', a.Cancelled, sum(b.CuryTotOrd) 'TotOrd'
From SoHeader a, SOLine b
where a.cpnyid = @CpnyID and
a.EDIPOId = @EDIPOID and
b.invtid = @InvtID and
a.cpnyid = b.cpnyid and
a.ordnbr = b.ordnbr and
a.cancelled = '0'
group by a.cpnyid, a.edipoid,  b.invtid, a.ordnbr,  a.Cancelled
GO
