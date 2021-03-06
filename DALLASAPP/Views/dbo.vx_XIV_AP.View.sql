USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vx_XIV_AP]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[vx_XIV_AP] as 
SELECT  
PD.Acct as PAcct, PD.BatNbr as PBatNbr, PD.ClearAmt as PClearAmt, PD.ClearDate as PClearDate, 
PD.CpnyId as PCpnyId, PD.CurrentNbr as PCurrent, PD.CuryDiscBal as PCuryDiscBal, PD.CuryDocBal as PCuryDocBal, 
PD.CuryEffDate as PCuryEffDate, PD.CuryId as PCuryId, PD.CuryMultDiv as PCuryMultDiv, PD.CuryOrigDocAmt as PCuryOrigDocAmt, 
PD.CuryRate as PCuryRate, PD.DiscBal as PDiscBal, PD.DiscDate as PDiscDate, PD.DocBal as PDocBal, 
PD.DocClass as PDocClass, PD.DocDate as PDocDate, PD.DocDesc as PDocDesc, PD.DocType as PDocType, PD.DueDate as PDueDate, 
PD.InvcDate as PInvcDate, PD.InvcNbr as PInvcNbr, PD.MasterDocNbr as PMasterDocNbr, PD.OpenDoc as POpenDoc, PD.OrigDocAmt as POrigDocAmt, 
PD.PayDate as PPayDate, PD.PerClosed as PPerClosed, PD.PerEnt as PPerEnt, PD.PerPost as PPerPost, PD.PONbr as PPONbr, 
PD.ProjectId as PProjectId, PD.RefNbr as PRefNbr, PD.RGOLAmt as PRGOLAmt, PD.Rlsed as PRlsed, 
PD.Selected as PSelected, PD.Status as PStatus, 
PD.Sub as PSub, PD.Terms as PTerms, PD.User1 as PUser1, PD.User2 as PUser2, PD.User3 as PUser3, 
PD.User4 as PUser4, PD.User5 as PUser5, PD.User6 as PUser6, PD.User7 as PUser7, 
PD.User8 as PUser8, ' ' as BStatus, V.VendId as VVendid, V.Name as VName,
AJ.AdjAmt as AdjAmt,  AJ.AdjBatNbr as AdjBatNbr, AJ.CuryAdjdAmt as AdjCuryAdjdAmt,
AJ.CuryAdjdDiscAmt as AdjCuryAdjdDiscAmt, AJ.CuryAdjdRate as AdjCuryAdjdRate, 
AJ.CuryAdjgAmt as AdjCuryAdjgAmt, AJ.CuryAdjgDiscAmt as AdjCuryAdjgDiscAmt,
AJ.CuryRGOLAmt as AdjCuryRGOLAmt, AJ.DateAppl as AdjDateAppl, AJ.AdjDiscAmt as AdjDiscAmt, AJ.PerAppl as AdjPerAppl,
RD.Acct as RAcct, RD.BatNbr as RBatNbr, RD.ClearAmt as RClearAmt, RD.ClearDate as RClearDate,
RD.CpnyId as RCpnyId, RD.CurrentNbr as RCurrent, RD.CuryDiscBal as RCuryDiscBal, RD.CuryDocBal as RCuryDocBal, 
RD.CuryEffDate as RCuryEffDate, RD.CuryId as RCuryId, RD.CuryMultDiv as RCuryMultDiv, RD.CuryOrigDocAmt as RCuryOrigDocAmt,
RD.CuryRate as RCuryRate, RD.DiscBal as RDiscBal, RD.DiscDate as RDiscDate, RD.DocBal as RDocBal, 
RD.DocClass as RDocClass, RD.DocDate as RDocDate, RD.DocDesc as RDocDesc, RD.DocType as RDocType, RD.DueDate as RDueDate, 
RD.InvcDate as RInvcDate, RD.InvcNbr as RInvcNbr, RD.MasterDocNbr as RMasterDocNbr, RD.OpenDoc as ROpenDoc, RD.OrigDocAmt as ROrigDocAmt, 
RD.PayDate as RPayDate, RD.PerClosed as RPerClosed, RD.PerEnt as RPerEnt, RD.PerPost as RPerPost, RD.PONbr as RPONbr, 
RD.ProjectId as RProjectId, RD.RefNbr as RRefNbr, RD.RGOLAmt as RRGOLAmt, RD.Rlsed as RRlsed, 
RD.Selected as RSelected, RD.Status as RStatus,
RD.Sub as RSub, RD.Terms as RTerms, RD.User1 as RUser1, RD.User2 as RUser2, RD.User3 as RUser3, 
RD.User4 as RUser4, RD.User5 as RUser5, RD.User6 as RUser6, RD.User7 as RUser7, 
RD.User8 as RUser8, PD.TStamp as TStamp
FROM ((APDoc AS PD INNER JOIN Vendor V ON PD.VendId = V.VendId) 
LEFT JOIN APAdjust AJ ON (PD.RefNbr = AJ.AdjdRefNbr) AND (PD.DocType = AJ.AdjdDocType) AND (PD.VendId = AJ.VendId)) 
LEFT JOIN APDoc AS RD ON (AJ.AdjgRefNbr = RD.RefNbr) AND (AJ.AdjgDocType = RD.DocType) AND (AJ.AdjgSub = RD.Sub) 
AND (AJ.AdjgAcct = RD.Acct) AND (AJ.VendId = RD.VendId)
WHERE PD.DocClass = 'N'

UNION

SELECT  
PD.Acct as PAcct, PD.BatNbr as PBatNbr, PD.ClearAmt as PClearAmt, PD.ClearDate as PClearDate, 
PD.CpnyId as PCpnyId, PD.CurrentNbr as PCurrent, PD.CuryDiscBal as PCuryDiscBal, PD.CuryDocBal as PCuryDocBal, 
PD.CuryEffDate as PCuryEffDate, PD.CuryId as PCuryId, PD.CuryMultDiv as PCuryMultDiv, PD.CuryOrigDocAmt as PCuryOrigDocAmt, 
PD.CuryRate as PCuryRate, PD.DiscBal as PDiscBal, PD.DiscDate as PDiscDate, PD.DocBal as PDocBal, 
PD.DocClass as PDocClass, PD.DocDate as PDocDate, PD.DocDesc as PDocDesc, PD.DocType as PDocType, PD.DueDate as PDueDate, 
PD.InvcDate as PInvcDate, PD.InvcNbr as PInvcNbr, PD.MasterDocNbr as PMasterDocNbr, PD.OpenDoc as POpenDoc, PD.OrigDocAmt as POrigDocAmt, 
PD.PayDate as PPayDate, PD.PerClosed as PPerClosed, PD.PerEnt as PPerEnt, PD.PerPost as PPerPost, PD.PONbr as PPONbr, 
PD.ProjectId as PProjectId, PD.RefNbr as PRefNbr, PD.RGOLAmt as PRGOLAmt, PD.Rlsed as PRlsed, 
PD.Selected as PSelected, PD.Status as PStatus, 
PD.Sub as PSub, PD.Terms as PTerms, PD.User1 as PUser1, PD.User2 as PUser2, PD.User3 as PUser3, 
PD.User4 as PUser4, PD.User5 as PUser5, PD.User6 as PUser6, PD.User7 as PUser7, 
PD.User8 as PUser8, ' ' as BStatus, V.VendId as VVendid, V.Name as VName,
AJ.AdjAmt as AdjAmt,  AJ.AdjBatNbr as AdjBatNbr, AJ.CuryAdjdAmt as AdjCuryAdjdAmt,
AJ.CuryAdjdDiscAmt as AdjCuryAdjdDiscAmt, AJ.CuryAdjdRate as AdjCuryAdjdRate, 
AJ.CuryAdjgAmt as AdjCuryAdjgAmt, AJ.CuryAdjgDiscAmt as AdjCuryAdjgDiscAmt,
AJ.CuryRGOLAmt as AdjCuryRGOLAmt, AJ.DateAppl as AdjDateAppl, AJ.AdjDiscAmt as AdjDiscAmt, AJ.PerAppl as AdjPerAppl,
RD.Acct as RAcct, RD.BatNbr as RBatNbr, RD.ClearAmt as RClearAmt, RD.ClearDate as RClearDate,
RD.CpnyId as RCpnyId, RD.CurrentNbr as RCurrent, RD.CuryDiscBal as RCuryDiscBal, RD.CuryDocBal as RCuryDocBal, 
RD.CuryEffDate as RCuryEffDate, RD.CuryId as RCuryId, RD.CuryMultDiv as RCuryMultDiv, RD.CuryOrigDocAmt as RCuryOrigDocAmt, 
RD.CuryRate as RCuryRate, RD.DiscBal as RDiscBal, RD.DiscDate as RDiscDate, RD.DocBal as RDocBal, 
RD.DocClass as RDocClass, RD.DocDate as RDocDate, RD.DocDesc as RDocDesc, RD.DocType as RDocType, RD.DueDate as RDueDate, 
RD.InvcDate as RInvcDate, RD.InvcNbr as RInvcNbr, RD.MasterDocNbr as RMasterDocNbr, RD.OpenDoc as ROpenDoc, RD.OrigDocAmt as ROrigDocAmt, 
RD.PayDate as RPayDate, RD.PerClosed as RPerClosed, RD.PerEnt as RPerEnt, RD.PerPost as RPerPost, RD.PONbr as RPONbr, 
RD.ProjectId as RProjectId, RD.RefNbr as RRefNbr, RD.RGOLAmt as RRGOLAmt, RD.Rlsed as RRlsed, 
RD.Selected as RSelected, RD.Status as RStatus,
RD.Sub as RSub, RD.Terms as RTerms, RD.User1 as RUser1, RD.User2 as RUser2, RD.User3 as RUser3, 
RD.User4 as RUser4, RD.User5 as RUser5, RD.User6 as RUser6, RD.User7 as RUser7, 
RD.User8 as RUser8, PD.TStamp as TStamp
FROM ((APDoc AS PD INNER JOIN Vendor V ON PD.VendId = V.VendId) 
LEFT JOIN APAdjust AJ ON (PD.RefNbr = AJ.AdjgRefNbr) and PD.DocType = AJ.AdjgDocType and PD.Sub = AJ.AdjgSub
AND PD.Acct = AJ.AdjgAcct AND PD.Vendid = AJ.Vendid)
LEFT JOIN APDoc RD ON AJ.AdjdDocType = RD.DocType AND AJ.AdjdRefNbr = RD.RefNbr and AJ.Vendid = RD.Vendid
WHERE PD.DocClass='C'
GO
