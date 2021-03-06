USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vr_PSSFA670]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_PSSFA670] AS
-- APTran Records
  SELECT 'AP' AS 'Module', A.BatNbr AS 'AP_BatNbr', A.RefNbr AS 'AP_RefNbr', A.Acct, A.Sub, A.TranDesc, A.PerPost, A.TranAmt, A.CuryTranAmt, A.CuryId,  A.TranType AS 'AP_DocType',  T.RefNbr AS 'APRecords_RefNbr', V.Name AS 'VENDor_Name', A.CpnyID, D.PONbr, D.PerClosed, '1' as 'Vouchered' 
 FROM   (((APTran A INNER JOIN PSSFAAssetCat C ON A.Acct=C.Acct) LEFT OUTER JOIN PSSFAAPRecords T ON ((A.RefNbr=T.RefNbr) AND (A.LineNbr=T.APLineNbr)) AND (A.LineId=T.APLineId)) LEFT OUTER JOIN VENDor V ON A.VENDId=V.VENDId) LEFT OUTER JOIN APDoc D ON ((A.BatNbr=D.BatNbr) AND (A.RefNbr=D.RefNbr)) AND (A.trantype=D.DocType)
 WHERE  (A.trantype='AC' OR A.trantype='AD' OR A.trantype='VO') AND (A.TranAmt>0 or A.CuryTranAmt > 0) AND A.Rlsed=1 
 
 UNION ALL
---- POTran records - Vouchered 
 SELECT 'PO' AS 'Module', ({fn ifnull((SELECT BatNbr FROM apdoc WHERE cpnyid = P.CpnyID AND  doctype in ('VO','AD','AC') AND refnbr = (SELECT aprefno FROM poreceipt WHERE (vouchstage = 'f' or vouchstage = 'p') AND cpnyid = P.CpnyID AND rcptnbr = P.RcptNbr  )) ,'')}) AS 'BatNbr', E.APRefno AS 'APRefNbr',  P.Acct,  P.Sub, P.InvtID,  P.PerPost, P.ExtCost, P.CuryExtCost, P.CuryId, ({fn ifnull((SELECT doctype FROM apdoc WHERE cpnyid = P.CpnyID AND  doctype in ('VO','AD','AC') AND rlsed = 1 AND refnbr = (SELECT aprefno FROM poreceipt WHERE (vouchstage = 'f' or vouchstage = 'p') AND cpnyid = P.CpnyID AND rcptnbr = P.RcptNbr  )) ,'')}), ({fn ifnull((SELECT distinct top 1 refnbr FROM PSSFAaprecords WHERE porcptnbr = P.RcptNbr AND polineref = P.LineRef AND porcptBatNbr = P.BatNbr),'')}) AS 'APRecords_RefNbr', V.Name AS 'Vendor_Name', P.CpnyID,  P.PONbr, ({fn ifnull((SELECT perclosed FROM apdoc WHERE cpnyid = P.CpnyID AND  doctype in ('VO','AD','AC') AND rlsed = 1 AND refnbr = (SELECT aprefno FROM poreceipt WHERE (vouchstage = 'f' or vouchstage = 'p') AND cpnyid = P.CpnyID AND rcptnbr = P.RcptNbr  )) ,'')}), '1' as 'Vouchered' 
 FROM   (POTran P LEFT OUTER JOIN POReceipt E ON P.RcptNbr=E.RcptNbr) INNER JOIN PSSFAAssetCat C ON P.Acct=C.Acct LEFT OUTER JOIN VENDor V ON P.VENDId=V.VENDId
 WHERE   P.VouchStage='F' AND (P.ExtCost > 0 or P.CuryExtCost > 0)

  UNION ALL
-- POTran records - Not vouchered
 SELECT 'PO' AS 'Module', P.Batnbr AS 'BatNbr', P.RcptNbr AS 'APRefNbr',  P.Acct,  P.Sub, P.InvtID,  P.PerPost, P.ExtCost, P.CuryExtCost, P.CuryId, 
 AP_DocType = CASE TranType
	WHEN 'R' THEN 'VO'
    WHEN 'X' THEN 'AD'
    ELSE 'VO'
 END, ({fn ifnull((SELECT distinct refnbr FROM PSSFAaprecords WHERE porcptnbr = P.RcptNbr AND polineref = P.LineRef AND porcptBatNbr = P.BatNbr),'')}) AS 'APRecords_RefNbr', V.Name AS 'Vendor_Name', P.CpnyID,  P.PONbr, '', '0' as 'Vouchered' 
 FROM   POTran P  INNER JOIN PSSFAAssetCat C ON P.Acct=C.Acct LEFT OUTER JOIN VENDor V ON P.VENDId=V.VENDId  
 WHERE   P.TranType in ('R','X')
GO
