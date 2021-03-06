USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_03MIN]    Script Date: 12/21/2015 14:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--done
CREATE VIEW [dbo].[xvr_03MIN]

AS

SELECT     RTRIM(d.Acct) + RTRIM(d.DocType) + RTRIM(d.RecordID) + RTRIM(d.RefNbr) + RTRIM(d.Sub) AS APDocKey, RTRIM(t.Acct) + RTRIM(t.BatNbr) 
                      + RTRIM(t.RecordID) + RTRIM(t.RefNbr) + RTRIM(t.Sub) AS APTranKey, RTRIM(a.AdjdDocType) + RTRIM(a.AdjdRefNbr) + RTRIM(a.AdjgAcct) 
                      + RTRIM(a.AdjgDocType) + RTRIM(a.AdjgRefNbr) + RTRIM(a.AdjgSub) + RTRIM(a.VendId) AS APAdjustKey, d.InvcNbr AS ClientInvoiceNbr, d.OrigDocAmt, 
                      t.VendId AS VendorID, t.RefNbr, t.trantype, t.TranDate, t.Acct AS TranAcct, t.DrCr AS TranDRCR, t.PerPost AS TranPerPost, t.TranAmt, 
                      t.ProjectID AS TranProject, v.Name AS VendorName, v.User5 AS EthnicOrigin, v.User2 AS ExpenditureType, ISNULL(p.customer, '') AS ProjectCustomer, 
                      a.AdjAmt, a.AdjgPerPost, v.City AS VendorCity, v.State AS VendorState, CASE WHEN t .trantype IN ('VO', 'AD') AND 
                      t .drcr = 'D' THEN 0 WHEN t .trantype IN ('AC') AND t .drcr = 'C' THEN 0 ELSE 1 END AS SortOrder
FROM         dbo.APDoc AS d INNER JOIN
                      dbo.APAdjust AS a ON d.RefNbr = a.AdjdRefNbr INNER JOIN
                      dbo.APTran AS t ON d.RefNbr = t.RefNbr LEFT OUTER JOIN
                      dbo.Vendor AS v ON d.VendId = v.VendId LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON t.ProjectID = p.project
WHERE     (d.DocBal <> d.OrigDocAmt) AND (d.DocType IN ('VO', 'AD', 'AC'))
GO
