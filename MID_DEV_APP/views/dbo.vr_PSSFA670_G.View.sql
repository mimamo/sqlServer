USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vr_PSSFA670_G]    Script Date: 12/21/2015 14:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_PSSFA670_G] AS
 SELECT  G.Acct,  ({fn ifnull((SELECT distinct top 1 assetid FROM PSSFAAPRecords WHERE batnbr = g.batnbr and acct = g.acct and sub = g.sub and refnbr = G.refnbr AND aplinenbr = G.LineNbr AND aplineid = G.lineid),'')}) AS 'APRecords_RefNbr', G.Batnbr , G.CpnyID, g.CRAmt, G.DRAmt, g.Module,  G.PerPost, G.RefNbr,  G.Sub, G.LineId, G.LineNbr,
TranAmt = CASE
	WHEN g.DRAmt <> 0 then abs(g.DRAmt)
    WHEN g.CRAmt <> 0 then abs(g.CRAmt)
END,
CuryTranAmt = CASE
	WHEN g.CuryDRAmt <> 0 then abs(g.CuryDRAmt)
    WHEN g.CuryCRAmt <> 0 then abs(g.CuryCRAmt)
END,
G.CuryId,G.TranDate, G.TranDesc,    
TranType = CASE 
	WHEN g.DRAmt >= 0 and g.CRAmt = 0 then 'DR'
    WHEN g.DRAmt < 0 and g.CRAmt = 0  then 'CR'
    WHEN g.CRAmt >= 0 and g.DRAmt = 0 then 'CR'
    WHEN g.CRAmt < 0 and g.DRAmt = 0 then 'DR'
	ELSE ' WHATEVER'			
END 
 FROM   GLTran G  INNER JOIN PSSFAAssetCat C ON G.Acct=C.Acct 
 WHERE  Module = 'GL' and rlsed = 1 and batnbr not in (select batnbr from batch WHERE module = 'GL' and jrnltype = 'FA' and crtd_prog like 'FA%')
GO
