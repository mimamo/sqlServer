select t.acct, a.*
from
(SELECT  d.CustId, d.ProjectID, d.BatSeq, d.BatNbr, ISNULL(p.purchase_order_num, '') AS ClientRefNum, ISNULL(p.project_desc, '') AS JobDescr, 
                      ISNULL(p.pm_id02, '') AS ProdCode, d.RefNbr, c.ClassId, d.DueDate, d.DocDate, d.DocType, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryOrigDocAmt AS CuryOrigDocAmt, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryDocBal AS CuryDocBal, b.AvgDayToPay, d.CpnyID
FROM         dbo.ARDoc AS d INNER JOIN
                      dbo.AR_Balances AS b ON d.CustId = b.CustID LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON d.ProjectID = p.project LEFT OUTER JOIN
                      dbo.Customer AS c ON d.CustId = c.CustId 
WHERE     (d.Rlsed = 1) AND (d.CuryDocBal <> 0))a 
INNER JOIN dbo.ARTran AS t ON (a.BatNbr = t.BatNbr and a.ProjectID = t.ProjectID and a.RefNbr = t.RefNbr) where t.Acct = '1040'


SELECT  d.CustId, d.ProjectID, d.BatSeq, d.BatNbr, ISNULL(p.purchase_order_num, '') AS ClientRefNum, ISNULL(p.project_desc, '') AS JobDescr, 
                      ISNULL(p.pm_id02, '') AS ProdCode, d.RefNbr, c.ClassId, d.DueDate, d.DocDate, d.DocType, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryOrigDocAmt AS CuryOrigDocAmt, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryDocBal AS CuryDocBal, b.AvgDayToPay, d.CpnyID
FROM         dbo.ARDoc AS d INNER JOIN
                      dbo.AR_Balances AS b ON d.CustId = b.CustID LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON d.ProjectID = p.project LEFT OUTER JOIN
                      dbo.Customer AS c ON d.CustId = c.CustId 
WHERE     (d.Rlsed = 1) AND (d.CuryDocBal <> 0)
and d.ProjectID NOT IN (
select a.ProjectID
from
(SELECT  d.CustId, d.ProjectID, d.BatSeq, d.BatNbr, ISNULL(p.purchase_order_num, '') AS ClientRefNum, ISNULL(p.project_desc, '') AS JobDescr, 
                      ISNULL(p.pm_id02, '') AS ProdCode, d.RefNbr, c.ClassId, d.DueDate, d.DocDate, d.DocType, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryOrigDocAmt AS CuryOrigDocAmt, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryDocBal AS CuryDocBal, b.AvgDayToPay, d.CpnyID
FROM         dbo.ARDoc AS d INNER JOIN
                      dbo.AR_Balances AS b ON d.CustId = b.CustID LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON d.ProjectID = p.project LEFT OUTER JOIN
                      dbo.Customer AS c ON d.CustId = c.CustId 
WHERE     (d.Rlsed = 1) AND (d.CuryDocBal <> 0))a 
LEFT OUTER JOIN dbo.ARTran AS t ON (a.BatNbr = t.BatNbr and a.ProjectID = t.ProjectID and a.RefNbr = t.RefNbr) where t.Acct = '1040')


 
SELECT     d.CustId, d.ProjectID, ISNULL(p.purchase_order_num, '') AS ClientRefNum, ISNULL(p.project_desc, '') AS JobDescr, ISNULL(p.pm_id02, '') AS ProdCode,
                       d.RefNbr, c.ClassId, d.DueDate, d.DocDate, d.DocType, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryOrigDocAmt AS CuryOrigDocAmt, CASE WHEN d .DocType IN ('IN', 'DM', 'FI', 'NC', 'AD') 
                      THEN 1 ELSE - 1 END * d.CuryDocBal AS CuryDocBal, b.AvgDayToPay, d.CpnyID, d.BatSeq, d.BatNbr
FROM         dbo.ARDoc AS d INNER JOIN
                      dbo.AR_Balances AS b ON d.CustId = b.CustID LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON d.ProjectID = p.project LEFT OUTER JOIN
                      dbo.Customer AS c ON d.CustId = c.CustId
WHERE     (d.Rlsed = 1) AND (d.CuryDocBal <> 0) and d.BatNbr = '104420'
and p.project = '04218211AGY' 
 


select * from ARTran where ProjectID = '04218211AGY'



SELECT     t.BatNbr, t.RefNbr AS Parent, d.Acct, d.CpnyID, d.Sub, 1 AS Ord, t.VendId, d.Status AS dStatus, t.RefNbr, d.DueDate, d.PayDate, d.DiscDate, d.DocDate, 
                      d.InvcNbr, t.LineType, d.InvcDate, t.trantype, t.PerEnt, d.MasterDocNbr, d.S4Future11, t.PerPost, d.PerClosed, 
                      t.TranAmt * (CASE WHEN t .TranType IN ('AD', 'PP') THEN - 1 ELSE 1 END) AS OrigTranAmt, 
                      CASE WHEN t .TranType = 'AD' THEN - t .TranAmt - isnull
                          ((SELECT     - SUM(j.adjamt)
                              FROM         APAdjust j
                              WHERE     t .refnbr = j.adjdrefnbr AND adjddoctype = 'AD'), 0) WHEN t .TranType = 'PP' THEN isnull
                          ((SELECT     - SUM(j.adjamt)
                              FROM         APAdjust j
                              WHERE     t .refnbr = j.adjdrefnbr AND adjddoctype = 'PP'), 0) ELSE t .TranAmt END AS TranAmt, t.CuryTranAmt * (CASE WHEN t .TranType IN ('AD', 
                      'PP') THEN - 1 ELSE 1 END) AS CuryOrigTranAmt, CASE WHEN t .TranType = 'AD' THEN - t .CuryTranAmt - isnull
                          ((SELECT     - SUM(j.adjamt)
                              FROM         APAdjust j
                              WHERE     t .refnbr = j.adjdrefnbr AND adjddoctype = 'AD'), 0) WHEN t .TranType = 'PP' THEN isnull
                          ((SELECT     - SUM(j.curyadjdamt)
                              FROM         APAdjust j
                              WHERE     t .RefNbr = j.adjdrefnbr AND adjddoctype = 'PP'), 0) ELSE t .CuryTranAmt END AS CuryTranAmt, d.CuryId, d.DocType AS ParentType, 
                      SUBSTRING(v.Name, 1, 30) AS VName, v.Status AS vStatus, CASE WHEN d .Acct = '' THEN v.APAcct ELSE d .Acct END AS APAcct, 
                      CASE WHEN d .Sub = '' THEN v.APSub ELSE d .Sub END AS APSub, v.CuryId AS vCuryID, ISNULL(p.pm_id01, '') AS ClientID, ISNULL(p.pm_id02, '') 
                      AS ProdID
FROM         dbo.Vendor AS v INNER JOIN
                      dbo.APDoc AS d ON v.VendId = d.VendId LEFT OUTER JOIN
                      dbo.APTran AS t ON d.RefNbr = t.RefNbr AND d.VendId = t.VendId AND d.DocType = t.trantype AND t.DrCr = 'D' LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON t.ProjectID = p.project
WHERE     (d.Rlsed = 1) AND (d.DocType NOT IN ('CK', 'HC', 'ZC', 'VC', 'VM', 'VT')) AND (d.DocBal <> 0) OR
                      (d.Rlsed = 1) AND (d.DocType NOT IN ('CK', 'HC', 'ZC', 'VC', 'VM', 'VT')) AND (d.DocType = 'PP')