USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[PJPrjBgt1]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJPrjBgt1] AS

   SELECT 
      
      Project               = h.project,
      Act_Hrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.act_units 
                              ELSE 0 END) AS DEC(28,2)),

      Act_Rev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               h.Act_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Act_RevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               h.Act_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Act_Labor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.Act_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Act_Exp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               h.Act_Amount
                              ELSE 0 END) AS DEC(28,2)), 
      Commit_Hrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.Com_units 
                              ELSE 0 END) AS DEC(28,2)),

      Commit_Rev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               h.Com_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Commit_RevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               h.Com_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Commit_Labor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.Com_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Commit_Exp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               h.Com_Amount
                              ELSE 0 END) AS DEC(28,2)),

      EAC_Hrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.EAC_units 
                              ELSE 0 END) AS DEC(28,2)),

      EAC_Rev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               h.EAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      EAC_RevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               h.EAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      EAC_Labor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.EAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      EAC_Exp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               h.EAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      FAC_Hrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.FAC_units 
                              ELSE 0 END) AS DEC(28,2)),

      FAC_Rev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               h.FAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      FAC_RevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               h.FAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      FAC_Labor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.FAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      FAC_Exp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               h.FAC_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Total_Budget_Hrs        =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.Total_Budget_units 
                              ELSE 0 END) AS DEC(28,2)),

      Total_Budget_Rev        =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               h.Total_Budget_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Total_Budget_RevAdj     =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               h.Total_Budget_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Total_Budget_Labor      =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               h.Total_Budget_Amount
                              ELSE 0 END) AS DEC(28,2)),

      Total_Budget_Exp        =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               h.Total_Budget_Amount
                              ELSE 0 END) AS DEC(28,2))

FROM PJPTDRol h INNER JOIN PJAcct            a (NOLOCK)  ON h.Acct = a.Acct 
GROUP BY project
GO
