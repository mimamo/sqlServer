USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_03674d]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[xvr_03674d] 

AS

SELECT	v.Addr1
, v.Addr2
, v.APAcct
, v.APSub
, v.Attn
, v.City
, v.ClassID as 'PayGroup'
, v.Country
, v.Curr1099Yr
, v.CuryId
, v.CuryRateType
, v.DfltBox
, v.DfltOrdFromId
, v.EMailAddr
, v.ExpAcct
, v.ExpSub
, v.Fax
, v.[Name] as 'Vendor'
, v.Next1099Yr
, v.PayDateDflt
, h.PerNbr
, v.Phone
, v.PmtMethod
, v.Salut
, v.State
, v.Status
, v.TaxDflt
, v.TaxId00
, v.TaxId01
, v.TaxId02
, v.TaxId03
, v.TaxLocId
, v.TaxPost
, v.TaxRegNbr
, v.Terms
, v.TIN
, v.Vend1099
, v.VendId 'DSLVendID'
, v.Zip
, h.FiscYr
, CASE SUBSTRING(h.PerNbr,5,2) WHEN '01' THEN h.PtdPaymt00 WHEN '02' THEN h.PtdPaymt01
		WHEN '03' THEN h.PtdPaymt02 WHEN '04' THEN h.PtdPaymt03 WHEN '05' THEN h.PtdPaymt04
		WHEN '06' THEN h.PtdPaymt05 WHEN '07' THEN h.PtdPaymt06 WHEN '08' THEN h.PtdPaymt07
		WHEN '09' THEN h.PtdPaymt08 WHEN '10' THEN h.PtdPaymt09 WHEN '11' THEN h.PtdPaymt10
		WHEN '12' THEN h.PtdPaymt11 WHEN '13' THEN h.PtdPaymt12 ELSE 0 END as 'PtdPaymt'
, CASE SUBSTRING(h.PerNbr,5,2) WHEN '01' THEN h.PtdPurch00 WHEN '02' THEN h.PtdPurch01
		WHEN '03' THEN h.PtdPurch02 WHEN '04' THEN h.PtdPurch03 WHEN '05' THEN h.PtdPurch04
		WHEN '06' THEN h.PtdPurch05 WHEN '07' THEN h.PtdPurch06 WHEN '08' THEN h.PtdPurch07
		WHEN '09' THEN h.PtdPurch08 WHEN '10' THEN h.PtdPurch09 WHEN '11' THEN h.PtdPurch10
		WHEN '12' THEN h.PtdPurch11 WHEN '13' THEN h.PtdPurch12 ELSE 0 END as 'PtdPurch'
, COALESCE(h.YtdPurch, 0) as 'YtdPurch'
, COALESCE(h.YtdPaymt, 0) as 'YtdPaymt'
, b.LastChkDate
, b.LastVODate
, COALESCE(h.YtdCrAdjs, 0) as 'YtdCrAdjs'
, COALESCE(h.YtdDrAdjs, 0) as 'YtdDrAdjs'
, COALESCE(h.YtdDiscTkn, 0) as 'YtdDiscTkn'
, p.Descr as 'PODescr'
, t.Descr as 'TermsDescr'
, b.CYBox00
, b.CYBox01
, b.CYBox02
, b.CYBox03
, b.CYBox04
, b.CYBox05
, b.CYBox06
, b.CYBox07
, COALESCE(h.BegBal, 0) as 'BegBal'
, COALESCE(b.CurrBal, 0) as 'CurrBal'
, COALESCE(b.FutureBal, 0) as 'FutureBal'
, c.CpnyID
, c.RI_ID as 'cRI_ID'
, c.CpnyName
, COALESCE(bc.DecPl,0) as 'BalDecPl'
, COALESCE(hc.DecPl,0) as 'HistDecPl'
, v.User1 as 'DonovanVendID'
, v.User2 as 'VendorType'
, v.User3
, v.User4
, v.User5
, v.User6
, v.User7
, v.User8
FROM RptRuntime r JOIN RptCompany c ON r.RI_ID = c.RI_ID 
		AND r.ReportNbr ='03674' 
	CROSS JOIN Vendor v
	LEFT JOIN Terms t ON v.Terms = t.TermsId 
	LEFT JOIN POAddress p ON v.VendId = p.VendId
	LEFT JOIN AP_Balances b ON c.CpnyID = b.CpnyID 
		AND v.VendID = b.VendID
	LEFT JOIN APHist h ON v.VendID = h.VendID 
		AND c.CpnyID = h.CpnyID 
		AND v.PerNbr = h.PerNbr
	LEFT JOIN Currncy bc (NOLOCK) ON b.CuryID = bc.CuryID
	LEFT JOIN Currncy hc (NOLOCK) ON h.CuryID = hc.CuryID
WHERE r.ShortAnswer00 = 'FALSE' 
	OR b.CpnyID IS NOT NULL
GO
