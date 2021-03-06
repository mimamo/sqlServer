USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_03670s]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX


CREATE VIEW [dbo].[xvr_03670s] AS

SELECT	v.ClassID, v.VendID, v.Name, v.Status,
	v.Terms, v.Phone, YtdPurch=COALESCE(h.YtdPurch, 0), YtdPaymt=COALESCE(h.YtdPaymt, 0), b.LastChkDate, b.LastVODate,
	CurrBal=COALESCE(b.CurrBal, 0), FutureBal=COALESCE(b.FutureBal, 0), c.CpnyID, 
	cRI_ID=c.RI_ID, c.CpnyName, BalDecPl = COALESCE(bc.DecPl,0), HistDecPl = COALESCE(hc.DecPl,0),
        v.User1,v.User2,v.User3,v.User4,v.User5,v.User6,v.User7,v.User8

FROM	RptRuntime r INNER JOIN RptCompany c ON r.RI_ID=c.RI_ID AND r.ReportNbr ='03670' CROSS JOIN Vendor v
	LEFT JOIN AP_Balances b ON c.CpnyID=b.CpnyID AND v.VendID=b.VendID
	LEFT JOIN APHist h ON v.VendID=h.VendID AND c.CpnyID=h.CpnyID AND v.PerNbr=h.PerNbr
	LEFT JOIN Currncy bc (NOLOCK) ON b.CuryID=bc.CuryID
	LEFT JOIN Currncy hc (NOLOCK) ON h.CuryID=hc.CuryID
WHERE	r.ShortAnswer00='FALSE' OR b.CpnyID IS NOT NULL
GO
