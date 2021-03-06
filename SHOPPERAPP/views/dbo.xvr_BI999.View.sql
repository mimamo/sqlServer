USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_BI999]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xvr_BI999]

AS

SELECT G.acct As 'GLAcctRef'
, (G.Acct) + '-' + (A.descr) AS 'AccountDescr'
, G.FiscYr AS 'GLFiscalYear'
, G.Module as 'GLModule'
, G.JrnlType as 'JournalType'
, G.perent As 'GLPeriodEnt'
, G.PerPost as 'GLPerPost'
, G.RefNbr As 'GLInvoiceNo'
, G.ProjectId As 'JobID'
, SUM(G.CrAmt) + SUM(G.DrAmt) * - 1 AS 'Amount'
FROM GLTran G JOIN Account A ON G.Acct = A.Acct
WHERE G.Acct IN ('4630', '4631', '4625', '4645', '4510', '4600', '4300', '2303', '4640', '4255', '1242')
GROUP BY G.Acct, G.FiscYr, G.Module, G.JrnlType, G.RefNbr, A.Descr, G.perent, G.PerPost, g.projectID
GO
