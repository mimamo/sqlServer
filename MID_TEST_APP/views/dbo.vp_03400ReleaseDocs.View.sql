USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vp_03400ReleaseDocs]    Script Date: 12/21/2015 14:26:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_03400ReleaseDocs] AS

/****** File Name: 0308vp_03400ReleaseDocs			******/

/****** Select records to be release via document type.	******/

SELECT d.CuryId, d.CpnyID, CurPer = (RIGHT(RTRIM(s.PerNbr), 2)), 
       CurYr = (SUBSTRING(s.PerNbr, 1, 4)), d.DocDate, 
       w.UserAddress, d.PerPost, FiscYr = SUBSTRING(d.PerPost, 1, 4), d.VendId, 
       d.DocType , 
       d.OrigDocAmt, VendorAmt = CASE d.DocType
		WHEN 'AC' THEN d.OrigDocAmt 
		WHEN 'AD' THEN d.OrigDocAmt * -1
		WHEN 'VO' THEN d.OrigDocAmt
		ELSE d.OrigDocAmt
	END, bPerNbr = (RIGHT(RTRIM(d.PerPost), 2)),  d.RefNbr
FROM  APDoc d, WrkRelease w, APSetup  s (nolock) 
WHERE d.BatNbr = w.BatNbr AND w.Module = 'AP' 
  and d.DocType IN ('VO', 'AD', 'AC')
	and d.PrePay_Refnbr = ''

UNION ALL

SELECT d.CuryId, d.CpnyID, CurPer = (RIGHT(RTRIM(s.PerNbr), 2)), 
       CurYr = (SUBSTRING(s.PerNbr, 1, 4)), d.DocDate, 
       w.UserAddress, d.PerPost, FiscYr = SUBSTRING(d.PerPost, 1, 4), d.VendId, 
       d.DocType , 
       d.OrigDocAmt +
		isnull((select curyrgolamt from apadjust j
 			where d.refnbr = j.AdjdRefNbr AND d.doctype = j.adjddoctype and
			d.BatNbr = w.BatNbr AND w.Module = 'AP' AND j.s4future11 <> 'V' and
			d.doctype in ('VO', 'AC')), 0),
	VendorAmt = CASE d.DocType
		WHEN 'AC' THEN d.OrigDocAmt 
		WHEN 'AD' THEN d.OrigDocAmt * -1
		WHEN 'VO' THEN d.OrigDocAmt
		ELSE d.OrigDocAmt
		END
		+
		isnull((select curyrgolamt from apadjust j
 			where d.refnbr = j.AdjdRefNbr AND d.doctype = j.adjddoctype and
			d.BatNbr = w.BatNbr AND w.Module = 'AP' AND j.s4future11 <> 'V' and
			d.doctype in ('VO', 'AC')), 0),
	
	bPerNbr = (RIGHT(RTRIM(d.PerPost), 2)),  d.RefNbr
FROM  APDoc d, WrkRelease w, APSetup  s (nolock) 
WHERE d.BatNbr = w.BatNbr AND w.Module = 'AP' 
  and d.DocType IN ('VO', 'AD', 'AC')
	and d.PrePay_Refnbr <> ''

UNION ALL
SELECT dv.CuryId, dv.CpnyID, CurPer = (RIGHT(RTRIM(s.PerNbr), 2)), 
       CurYr = (SUBSTRING(s.PerNbr, 1, 4)), dc.DocDate,  
	w.UserAddress, dc.PerPost, FiscYr = SUBSTRING(dc.PerPost, 1, 4), dc.VendId, 'DT', 
	case when adjddoctype = 'AD' then adjdiscamt*-1 else adj.AdjdiscAmt end, 
        case when adjddoctype = 'AD' then adjdiscamt else adj.AdjdiscAmt * -1 end, 
        '', dc.RefNbr
FROM APDoc dc, APDOC dv,APAdjust Adj,APSetup s (nolock),WrkRelease w 
WHERE dc.BatNbr = w.BatNbr AND w.Module = 'AP' 
  AND dc.doctype = adj.adjgdoctype and dc.refnbr = adj.adjgrefnbr and dc.acct = adj.adjgacct
  and dc.sub = adj.adjgsub and adj.adjddoctype = dv.doctype 
  and adj.adjdrefnbr = dv.refnbr
  AND dc.DiscTkn <> 0 AND dc.DocType IN ('VC', 'CK', 'HC')

UNION All


SELECT dv.CuryId, dv.CpnyID, CurPer = (RIGHT(RTRIM(s.PerNbr), 2)), 
       CurYr = (SUBSTRING(s.PerNbr, 1, 4)), dc.DocDate, 
       w.UserAddress, dc.PerPost, FiscYr = SUBSTRING(dc.PerPost, 1, 4), dc.VendId, 
	DocType = CASE WHEN (dc.DocType = 'CK' OR dc.DocType = 'HC') THEN 'PA' ELSE dc.DocType END, 
	case when adjddoctype = 'AD' then adjamt*-1 else adj.AdjAmt end, 
       VendorAmt = case when adjddoctype = 'AD' then adjamt else adj.AdjAmt * -1 end,
	 bPerNbr = (RIGHT(RTRIM(dc.PerPost), 2)), 
        dc.RefNbr
FROM  APDoc dc, APDoc dv, APAdjust adj, APSetup s (nolock),WrkRelease w
WHERE  dc.BatNbr = w.BatNbr AND w.Module = 'AP' 
  AND dc.doctype = adj.adjgdoctype and dc.refnbr = adj.adjgrefnbr and dc.acct = adj.adjgacct
  and dc.sub = adj.adjgsub and adj.adjddoctype = dv.doctype 
  and adj.adjdrefnbr = dv.refnbr 
  and dc.DocType IN ('VC', 'CK', 'HC', 'ZC')
GO
