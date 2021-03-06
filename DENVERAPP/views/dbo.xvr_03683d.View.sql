USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_03683d]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_03683d]

AS

/*
Added project Per E. Eckhelhoff 7/29 KCW
*/

SELECT r.RI_ID
, r.ReportDate
, v.Parent
, v.Ord
, v.vCuryID
, v.APAcct
, v.APSub
, v.VendID
, v.VName
, v.vStatus
, v.dStatus
, v.RefNbr
, v.BatNbr
, v.CuryID
, v.DueDate
, CASE WHEN v.TranType = 'AD'
		THEN NULL 
		ELSE v.PayDate END as 'PayDate'
, v.DiscDate
, v.DocDate
, v.InvcNbr
, v.InvcDate
, v.ClientID
, v.ProdID
, v.TranType
, v.OrigTranAmt
, v.TranAmt
, v.CuryOrigTranAmt
, v.CuryTranAmt
, v.CpnyID
, v.MasterDocNbr
, v.S4Future11
, c.RI_ID as 'cRI_ID'
, c.CpnyName
, v.project				--Added to support project reporting per EE 7/29 KCW
,CASE WHEN r.ReportDate <= v.DueDate 
		THEN v.TranAmt 
		ELSE 0 END as 'Cur'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue00) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) >= 1 
		THEN v.TranAmt
		ELSE 0 END as 'Past00'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue01) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue00) 
		THEN v.TranAmt
		ELSE 0 END as 'Past01'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue02) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue01) 
		THEN v.TranAmt
		ELSE 0 END as 'Past02'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue02) 
		THEN v.TranAmt
		ELSE 0 END as 'Over02'
, CASE WHEN r.ReportDate <= v.DueDate 
		THEN v.CuryTranAmt 
		ELSE 0 END as 'cCur'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue00) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) >= 1 
		THEN v.CuryTranAmt
		ELSE 0 END as 'cPast00'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue01) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue00) 
		THEN v.CuryTranAmt
		ELSE 0 END as 'cPast01'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) <= CONVERT(INT, s.PastDue02) 
		AND DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue01) 
		THEN v.CuryTranAmt
		ELSE 0 END as 'cPast02'
, CASE WHEN DATEDIFF(Day, v.DueDate, r.ReportDate) > CONVERT(INT, s.PastDue02) 
		THEN v.CuryTranAmt
		ELSE 0 END as 'cOver02'
FROM xvr_03683VendorDetail v
	CROSS JOIN RptRuntime r
	CROSS JOIN APSetup s (NOLOCK)
	CROSS JOIN RptCompany c
WHERE v.TranAmt <> 0 
	AND r.ReportNbr = '03683' 
	AND v.CpnyID = c.CpnyID
GO
