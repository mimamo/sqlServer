USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_03683VendorDetail]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_03683VendorDetail]

AS

SELECT t.BatNbr
, t.RefNbr as 'Parent'
, d.Acct
, d.CpnyID
, d.Sub
, 1 as 'Ord'
, t.VendID
, d.Status as 'dStatus'
, t.RefNbr
, d.DueDate
, d.PayDate
, d.DiscDate
, d.DocDate
, d.InvcNbr
, t.LineType
, d.InvcDate
, t.TranType
, t.PerEnt
, d.MasterDocNbr
, d.S4Future11
, t.PerPost
, d.PerClosed
, t.TranAmt * (CASE WHEN t.TranType in ('AD', 'PP')
					THEN -1 
					ELSE 1 end) as 'OrigTranAmt'
, CASE WHEN t.TranType = 'AD' 
		THEN -t.TranAmt - isnull((select -sum(j.adjamt) from APAdjust j where t.refnbr = j.adjdrefnbr and adjddoctype = 'AD'),0)
		WHEN t.TranType = 'PP' 
		THEN isnull((select -sum(j.adjamt) from APAdjust j where t.refnbr = j.adjdrefnbr and adjddoctype = 'PP'),0)
		ELSE t.TranAmt end as 'TranAmt'
, t.CuryTranAmt * (CASE WHEN t.TranType in ('AD', 'PP') 
							THEN -1	
							ELSE 1 end) as 'CuryOrigTranAmt'
, CASE WHEN t.TranType = 'AD' 
		THEN -t.CuryTranAmt - isnull((select -sum(j.adjamt) from APAdjust j where t.refnbr = j.adjdrefnbr and adjddoctype = 'AD'),0)
		WHEN t.TranType = 'PP'
		THEN isnull((select -sum(j.curyadjdamt) from APAdjust j where t.RefNbr = j.adjdrefnbr and adjddoctype = 'PP'),0)
		ELSE t.CuryTranAmt end as 'CuryTranAmt'
, d.CuryID
, d.DocType as 'ParentType'
, SUBSTRING(v.Name, 1, 30) as 'VName'
, v.Status as 'vStatus'
, CASE WHEN d.Acct = '' 
		THEN v.APAcct 
		ELSE d.Acct end as 'APAcct'
, CASE WHEN d.Sub = '' 
		THEN v.APSub 
		ELSE d.Sub end as 'APSub'
, v.CuryID as 'vCuryID'
, isnull(p.pm_id01, '') as 'ClientID' 
, isnull(p.pm_id02, '') as 'ProdID'	
FROM Vendor v JOIN APDoc d ON v.VendID = d.VendID
	LEFT JOIN APTran t ON d.RefNbr = t.RefNbr
		AND d.VendID = t.VendID
		AND d.DocType = t.TranType
		AND t.DrCr = 'D'
	LEFT JOIN PJPROJ p ON t.ProjectID = p.project 
WHERE d.Rlsed = 1 
	AND d.DocType NOT IN ('CK','HC','ZC', 'VC', 'VM', 'VT') 
	AND (d.DocBal <> 0 OR d.DocType = 'PP')
GO
