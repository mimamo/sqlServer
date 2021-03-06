USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_AP201]    Script Date: 12/21/2015 16:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[xvr_AP201] AS
SELECT r.Ri_id
, t.Acct
, t.Sub
, d.Acct as dAcct
, d.Sub as dSub
, b.BatNbr
, t.DrCr
, t.ProjectID as 'JobNum'
, t.Qty
, RefNbr = COALESCE(d.RefNbr, t.RefNbr)
, t.TranAmt
, t.TranDesc
, t.UnitDesc
, t.UnitPrice
, b.CrTot
, b.CtrlTot
, d.OrigDocAmt
, b.CpnyId batchcpny
, d.DiscBal
, d.Disctkn
, d.DiscDate
, d.DocType
, d.DocDate
, b.DrTot
, d.DueDate
, b.EditScrnNbr
, d.InvcDate
, d.InvcNbr
, b.JrnlType
, b.NbrCycle
, CpnyID=coalesce(d.CpnyID, b.CpnyID)
, d.PayDate
, t.PerEnt
, t.PerPost
, d.PONbr
, b.Rlsed
, b.Status
, d.Terms
, VendID = COALESCE(d.VendID, t.VendId)
, cRI_ID = c.RI_ID
, c.CpnyName
, Name =  (SELECT v.Name FROM Vendor v WHERE v.VendID = COALESCE(d.VendID, t.VendID))
, ISNULL(p.project_desc, '') as 'Job'
, ISNULL(t.taskid, '') as 'FunctionID'
, ISNULL(p.pm_id01, '') as 'ClientID'
, ISNULL(p.pm_id02, '') as 'ProdID'
FROM Batch b LEFT OUTER JOIN APDoc d ON b.BatNbr = d.BatNbr AND b.Module = 'AP'
	LEFT OUTER JOIN APTran t ON b.BatNbr = t.BatNbr AND NOT (isnull(d.doctype, '') = 'VC' and isnull(d.status, '') != 'V') AND (d.RefNbr = t.RefNbr OR b.EditScrnNbr = '03060' OR (b.EditScrnNbr = '03040' and b.Rlsed = 0))
	INNER JOIN RptRunTime r ON (COALESCE(d.PerEnt, t.PerEnt) BETWEEN r.BegPerNbr AND r.EndPerNbr) OR
				   (COALESCE(d.PerPost, t.PerPost) BETWEEN r.BegPerNbr AND r.EndPerNbr)
	INNER JOIN RptCompany c ON b.CpnyID = c.CpnyID AND r.Ri_id = c.Ri_id
	LEFT OUTER JOIN APDoc mc ON mc.BatNbr = d.BatNbr AND mc.InvcNbr = d.RefNbr AND mc.VendID = d.VendID AND mc.DocType = 'VC' AND b.EditScrnNbr IN ('03010', '03020')
	LEFT OUTER JOIN PJPROJ p ON t.ProjectID = p.Project
WHERE b.EditScrnNbr NOT IN ('03010', '03020') 
	OR ISNULL(d.DocType,'') <> 'VC'
GO
