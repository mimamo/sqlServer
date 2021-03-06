USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vx_XIV_AR]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[vx_XIV_AR] as 
SELECT  
PD.AcctNbr as PAcctNbr, PD.AgentId as PAgentId, PD.ApplAmt as PApplAmt, PD.ApplBatNbr as PApplBatNbr,
PD.BankAcct as PBankAcct, PD.BankId as PBankId, PD.BankSub as PBankSub, PD.BatNbr as PBatNbr, 
PD.ClearDate as PClearDate, PD.CmmnAmt as PCmmnAmt, PD.CmmnPct as PCmmnPct, PD.CpnyId as PCpnyId,
PD.CurrentNbr as PCurrentNbr, PD.CuryApplAmt as PCuryApplAmt, PD.CuryClearAmt as PCuryClearAmt, PD.CuryCmmnAmt as PCuryCmmnAmt,	
PD.CuryDiscApplAmt As PCuryDiscApplAmt, PD.CuryDiscBal As PCuryDiscBal, PD.CuryDocBal As PCuryDocBal, PD.CuryEffDate As PCuryEffDate, 
PD.CuryId As PCuryId, PD.CuryOrigDocAmt As PCuryOrigDocAmt, PD.CuryRate As PCuryRate, PD.CuryRateType As PCuryRateType, 
PD.CustId As PCustId, PD.CustOrdNbr As PCustOrdNbr, PD.DiscApplAmt As PDiscApplAmt, PD.DiscBal As PDiscBal,  PD.DiscDate as PDiscDate,
PD.DocBal As PDocBal, PD.DocClass As PDocClass, PD.DocDate As PDocDate, PD.DocDesc As PDocDesc , 
PD.DocType As PDocType , PD.DueDate As PDueDate, PD.MasterDocNbr As PMasterDocNbr, PD.OpenDoc As POpenDoc, 
PD.OrdNbr As POrdNbr, PD.OrigDocAmt As POrigDocAmt, PD.OrigDocNbr As POrigDocNbr, PD.PerClosed as PPerClosed, PD.PerEnt As PPerEnt, 
PD.PerPost As PPerPost, PD.ProjectId As PProjectId, PD.RefNbr As PRefNbr, PD.RGOLAmt As PRGOLAmt, 
PD.Rlsed As PRlsed, PD.ShipmentNbr As PShipmentNbr, PD.SlsperId As PSlsperId, PD.Status As PStatus, 
PD.TaskId As PTaskId, PD.Terms As PTerms, PD.User1 As PUser1, PD.User2 As PUser2, 
PD.User3 As PUser3, PD.User4 As PUser4, PD.User5 As PUser5, PD.User6 As PUser6, 
PD.User7 As PUser7, PD.User8  As PUser8,
' ' as BStatus, 
C.CustId as CCustId, C.Name as CName, C.State as CState, C.Zip as CZip,
C.Territory as CTerritory, 
AJ.AdjAmt as AdjAmt,  AJ.AdjBatNbr as AdjBatNbr, AJ.AdjDiscAmt as AdjDiscAmt, AJ.CuryAdjdAmt as AdjCuryAdjdAmt, 
AJ.CuryAdjdCuryId as AdjCuryAdjdCuryId, AJ.CuryAdjdDiscAmt as AdjCuryAdjdDiscAmt, AJ.CuryAdjdRate as AdjCuryAdjdRate, 
AJ.CuryAdjgAmt as AdjCuryAdjgAmt, AJ.CuryAdjgDiscAmt as AdjCuryAdjgDiscAmt, AJ.CuryRGOLAmt as AdjCuryRGOLAmt, 
AJ.DateAppl as AdjDateAppl,
RD.AcctNbr as RAcctNbr, RD.AgentId as RAgentId, RD.ApplAmt as RApplAmt, RD.ApplBatNbr as RApplBatNbr,
RD.BankAcct as RBankAcct, RD.BankId as RBankId, RD.BankSub as RBankSub, RD.BatNbr as RBatNbr, 
RD.ClearDate as RClearDate, RD.CmmnAmt as RCmmnAmt, RD.CmmnPct as RCmmnPct, RD.CpnyId as RCpnyId,
RD.CurrentNbr as RCurrentNbr, RD.CuryApplAmt as RCuryApplAmt, RD.CuryClearAmt as RCuryClearAmt, RD.CuryCmmnAmt as RCuryCmmnAmt,	
RD.CuryDiscApplAmt as RCuryDiscApplAmt, RD.CuryDiscBal as RCuryDiscBal, RD.CuryDocBal as RCuryDocBal, RD.CuryEffDate as RCuryEffDate, 
RD.CuryId as RCuryId, RD.CuryOrigDocAmt as RCuryOrigDocAmt, RD.CuryRate as RCuryRate, RD.CuryRateType as RCuryRateType, 
RD.CustId as RCustId, RD.CustOrdNbr as RCustOrdNbr, RD.DiscApplAmt as RDiscApplAmt,  RD.DiscBal as RDiscBal,  RD.DiscDate as RDiscDate,
RD.DocBal as RDocBal, RD.DocClass as RDocClass, RD.DocDate as RDocDate, RD.DocDesc as RDocDesc , 
RD.DocType as RDocType , RD.DueDate as RDueDate, RD.MasterDocNbr as RMasterDocNbr, RD.OpenDoc as ROpenDoc, 
RD.OrdNbr as ROrdNbr, RD.OrigDocAmt as ROrigDocAmt, RD.OrigDocNbr as ROrigDocNbr, RD.PerClosed as RPerClosed, RD.PerEnt as RPerEnt, 
RD.PerPost as RPerPost, RD.ProjectId as RProjectId, RD.RefNbr as RRefNbr, RD.RGOLAmt as RRGOLAmt, 
RD.Rlsed as RRlsed, RD.ShipmentNbr as RShipmentNbr, RD.SlsperId as RSlsperId, RD.Status as RStatus, 
RD.TaskId as RTaskId, RD.Terms as RTerms, RD.User1 as RUser1, RD.User2 as RUser2, 
RD.User3 as RUser3, RD.User4 as RUser4, RD.User5 as RUser5, RD.User6 as RUser6, 
RD.User7 as RUser7, RD.User8  as RUser8,
PD.TStamp as TStamp 
FROM (((ARDoc AS PD INNER JOIN Customer C On PD.CustId = C.CustId) INNER JOIN Batch B ON PD.BatNbr = B.BatNbr) 
LEFT JOIN ARAdjust AJ ON PD.CustId = AJ.CustId AND PD.DocType = AJ.AdjdDocType AND PD.RefNbr = AJ.AdjdRefNbr ) 
LEFT JOIN ARDoc AS RD ON AJ.CustId = RD.CustId AND AJ.AdjgDocType = RD.DocType AND AJ.AdjgRefNbr = RD.RefNbr AND AJ.AdjgDocDate = RD.DocDate 

WHERE PD.DocClass = 'N' AND PD.DocType <> 'CM'

UNION

SELECT  
PD.AcctNbr as PAcctNbr, PD.AgentId as PAgentId, PD.ApplAmt as PApplAmt, PD.ApplBatNbr as PApplBatNbr,
PD.BankAcct as PBankAcct, PD.BankId as PBankId, PD.BankSub as PBankSub, PD.BatNbr as PBatNbr, 
PD.ClearDate as PClearDate, PD.CmmnAmt as PCmmnAmt, PD.CmmnPct as PCmmnPct, PD.CpnyId as PCpnyId,
PD.CurrentNbr as PCurrent, PD.CuryApplAmt as PCuryApplAmt, PD.CuryClearAmt as PCuryClearAmt, PD.CuryCmmnAmt as PCuryCmmnAmt,	
PD.CuryDiscApplAmt As PCuryDiscApplAmt, PD.CuryDiscBal As PCuryDiscBal, PD.CuryDocBal As PCuryDocBal, PD.CuryEffDate As PCuryEffDate, 
PD.CuryId As P, PD.CuryOrigDocAmt As PCuryOrigDocAmt, PD.CuryRate As PCuryRate, PD.CuryRateType As PCuryRateType, 
PD.CustId As PCustId, PD.CustOrdNbr As PCustOrdNbr,  PD.DiscApplAmt As PDiscApplAmt, PD.DiscBal As PDiscBal,  PD.DiscDate as PDiscDate,
PD.DocBal As PDocBal, PD.DocClass As PDocClass, PD.DocDate As PDocDate, PD.DocDesc As PDocDesc , 
PD.DocType As PDocType , PD.DueDate As PDueDate, PD.MasterDocNbr As PMasterDocNbr, PD.OpenDoc As POpenDoc, 
PD.OrdNbr As POrdNbr, PD.OrigDocAmt As POrigDocAmt, PD.OrigDocNbr As POrigDocNbr, PD.PerClosed as PPerClosed, PD.PerEnt As PPerEnt, 
PD.PerPost As PPerPost, PD.ProjectId As PProjectId, PD.RefNbr As PRefNbr, PD.RGOLAmt As PRGOLAmt, 
PD.Rlsed As PRlsed, PD.ShipmentNbr As PShipmentNbr, PD.SlsperId As PSlsperId, PD.Status As PStatus, 
PD.TaskId As PTaskId, PD.Terms As PTerms, PD.User1 As PUser1, PD.User2 As PUser2, 
PD.User3 As PUser3, PD.User4 As PUser4, PD.User5 As PUser5, PD.User6 As PUser6, 
PD.User7 As PUser7, PD.User8  As PUser8,
' ' as BStatus, 
C.CustId as CCustId, C.Name as CName, C.State as CState, C.Zip as CZip,
C.Territory as CTerritory, 
AJ.AdjAmt as AdjAmt,  AJ.AdjBatNbr as AdjBatNbr, AJ.AdjDiscAmt as AdjDiscAmt, AJ.CuryAdjdAmt as AdjCuryAdjdAmt, 
AJ.CuryAdjdCuryId as AdjCuryAdjdCuryId, AJ.CuryAdjdDiscAmt as AdjCuryAdjdDiscAmt, AJ.CuryAdjdRate as AdjCuryAdjdRate, 
AJ.CuryAdjgAmt as AdjCuryAdjgAmt, AJ.CuryAdjgDiscAmt as AdjCuryAdjgDiscAmt, AJ.CuryRGOLAmt as AdjCuryRGOLAmt, 
AJ.DateAppl as AdjDateAppl,
RD.AcctNbr as RAcctNbr, RD.AgentId as RAgentId, RD.ApplAmt as RApplAmt, RD.ApplBatNbr as RApplBatNbr,
RD.BankAcct as RBankAcct, RD.BankId as RBankId, RD.BankSub as RBankSub, RD.BatNbr as RBatNbr, 
RD.ClearDate as RClearDate, RD.CmmnAmt as RCmmnAmt, RD.CmmnPct as RCmmnPct, RD.CpnyId as RCpnyId,
RD.CurrentNbr as RCurrent, RD.CuryApplAmt as RCuryApplAmt, RD.CuryClearAmt as RCuryClearAmt, RD.CuryCmmnAmt as RCuryCmmnAmt,	
RD.CuryDiscApplAmt as RCuryDiscApplAmt, RD.CuryDiscBal as RCuryDiscBal, RD.CuryDocBal as RCuryDocBal, RD.CuryEffDate as RCuryEffDate, 
RD.CuryId as R, RD.CuryOrigDocAmt as RCuryOrigDocAmt, RD.CuryRate as RCuryRate, RD.CuryRateType as RCuryRateType, 
RD.CustId as RCustId, RD.CustOrdNbr as RCustOrdNbr, RD.DiscApplAmt as RDiscApplAmt, RD.DiscBal as RDiscBal,  RD.DiscDate as RDiscDate,
RD.DocBal as RDocBal, RD.DocClass as RDocClass, RD.DocDate as RDocDate, RD.DocDesc as RDocDesc , 
RD.DocType as RDocType , RD.DueDate as RDueDate, RD.MasterDocNbr as RMasterDocNbr, RD.OpenDoc as ROpenDoc, 
RD.OrdNbr as ROrdNbr, RD.OrigDocAmt as ROrigDocAmt, RD.OrigDocNbr as ROrigDocNbr, RD.PerClosed as RPerClosed, RD.PerEnt as RPerEnt, 
RD.PerPost as RPerPost, RD.ProjectId as RProjectId, RD.RefNbr as RRefNbr, RD.RGOLAmt as RRGOLAmt, 
RD.Rlsed as RRlsed, RD.ShipmentNbr as RShipmentNbr, RD.SlsperId as RSlsperId, RD.Status as RStatus, 
RD.TaskId as RTaskId, RD.Terms as RTerms, RD.User1 as RUser1, RD.User2 as RUser2, 
RD.User3 as RUser3, RD.User4 as RUser4, RD.User5 as RUser5, RD.User6 as RUser6, 
RD.User7 as RUser7, RD.User8  as RUser8,
PD.TStamp as TStamp 
FROM ((ARDoc AS PD INNER JOIN Customer C ON PD.CustId = C.CustId) 
LEFT JOIN ARAdjust AJ ON PD.CustId = AJ.CustId and PD.DocType = AJ.AdjgDocType AND PD.RefNbr = AJ.AdjgRefNbr  and PD.DocDate = AJ.AdjgDocDate)
LEFT JOIN ARDoc RD ON AJ.CustId = RD.CustId AND AJ.AdjdDocType = RD.DocType AND AJ.AdjdRefNbr = RD.RefNbr  

WHERE PD.DocClass='P'  OR PD.DocType = 'CM'
GO
