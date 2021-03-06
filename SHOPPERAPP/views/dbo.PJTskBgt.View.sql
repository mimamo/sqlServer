USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[PJTskBgt]    Script Date: 12/21/2015 16:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJTskBgt] AS

   SELECT 
      
      Project                = h.project,
      Task                   = h.task,
      ACT_Hrs                = h.Act_hrs,
      ACT_Rev                = h.Act_rev,
      ACT_RevAdj             = h.Act_revadj,
      ACT_Labor              = h.Act_labor,
      ACT_Exp                = h.Act_exp,
      ACT_Margin             = CAST((h.Act_rev + h.Act_revadj - h.Act_labor - h.Act_exp)AS DEC(28,2)),
      ACT_MarginPct          = CAST(CASE WHEN (h.Act_rev + h.Act_revadj) <> 0.00 THEN (h.Act_rev + h.Act_revadj - h.Act_labor - h.Act_exp)/(h.Act_rev + h.Act_revadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      ACT_Rate               = CAST(CASE WHEN h.Act_hrs <> 0.00 THEN (h.Act_rev + h.Act_revadj - h.Act_exp) / (h.Act_hrs)ELSE 0.00 END AS DEC(28,2)),
      ACT_NLM                = CAST(CASE WHEN h.Act_labor <> 0.00 THEN (h.Act_rev + h.Act_revadj - h.Act_exp) / (h.Act_labor)ELSE 0.00 END AS DEC(28,2)),
      COMMIT_Hrs             = h.Commit_hrs,
      COMMIT_Rev             = h.Commit_rev,
      COMMIT_RevAdj          = h.Commit_revadj,
      COMMIT_Labor           = h.Commit_labor,
      COMMIT_Exp             = h.Commit_exp,
      EAC_Hrs                = h.EAC_hrs,
      EAC_Rev                = h.EAC_rev,
      EAC_RevAdj             = h.EAC_revadj,
      EAC_Labor              = h.EAC_labor,
      EAC_Exp                = h.EAC_exp,
      EAC_Margin             = CAST((h.EAC_rev + h.EAC_revadj - h.EAC_labor - h.EAC_exp)AS DEC(28,2)),
      EAC_MarginPct          = CAST(CASE WHEN (h.EAC_rev + h.EAC_revadj) <> 0.00 THEN (h.EAC_rev + h.EAC_revadj - h.EAC_labor - h.EAC_exp)/(h.EAC_rev + h.EAC_revadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      EAC_Rate               = CAST(CASE WHEN h.EAC_hrs <> 0.00 THEN (h.EAC_rev + h.EAC_revadj - h.EAC_exp) / (h.EAC_hrs)ELSE 0.00 END AS DEC(28,2)),
      EAC_NLM                = CAST(CASE WHEN h.EAC_labor <> 0.00 THEN (h.EAC_rev + h.EAC_revadj - h.EAC_exp) / (h.EAC_labor)ELSE 0.00 END AS DEC(28,2)),
      FAC_Hrs                = h.FAC_hrs,
      FAC_Rev                = h.FAC_rev,
      FAC_RevAdj             = h.FAC_revadj,
      FAC_Labor              = h.FAC_labor,
      FAC_Exp                = h.FAC_exp,
      FAC_Margin             = CAST((h.FAC_rev + h.FAC_revadj - h.FAC_labor - h.FAC_exp)AS DEC(28,2)),
      FAC_MarginPct          = CAST(CASE WHEN (h.FAC_rev + h.FAC_revadj) <> 0.00 THEN (h.FAC_rev + h.FAC_revadj - h.FAC_labor - h.FAC_exp)/(h.FAC_rev + h.FAC_revadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      FAC_Rate               = CAST(CASE WHEN h.FAC_hrs <> 0.00 THEN (h.FAC_rev + h.FAC_revadj - h.FAC_exp) / (h.FAC_hrs)ELSE 0.00 END AS DEC(28,2)),
      FAC_NLM                = CAST(CASE WHEN h.FAC_labor <> 0.00 THEN (h.FAC_rev + h.FAC_revadj - h.FAC_exp) / (h.FAC_labor)ELSE 0.00 END AS DEC(28,2)),
      Total_Budget_Hrs       = h.Total_Budget_hrs,
      Total_Budget_Rev       = h.Total_Budget_rev,
      Total_Budget_RevAdj    = h.Total_Budget_revadj,
      Total_Budget_Labor     = h.Total_Budget_labor,
      Total_Budget_Exp       = h.Total_Budget_exp,
      Total_Budget_Margin    = CAST((h.Total_Budget_rev + h.Total_Budget_revadj - h.Total_Budget_labor - h.Total_Budget_exp)AS DEC(28,2)),
      Total_Budget_MarginPct = CAST(CASE WHEN (h.Total_Budget_rev + h.Total_Budget_revadj) <> 0.00 THEN (h.Total_Budget_rev + h.Total_Budget_revadj - h.Total_Budget_labor - h.Total_Budget_exp)/(h.Total_Budget_rev + h.Total_Budget_revadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      Total_Budget_Rate      = CAST(CASE WHEN h.Total_Budget_hrs <> 0.00 THEN (h.Total_Budget_rev + h.Total_Budget_revadj - h.Total_Budget_exp) / (h.Total_Budget_hrs)ELSE 0.00 END AS DEC(28,2)),
      Total_Budget_NLM       = CAST(CASE WHEN h.Total_Budget_labor <> 0.00 THEN (h.Total_Budget_rev + h.Total_Budget_revadj - h.Total_Budget_exp) / (h.Total_Budget_labor)ELSE 0.00 END AS DEC(28,2)),
      Manager1               = p.manager1,
      Manager2               = p.manager2
      
FROM PJTskBgt1 h JOIN PjProj p
                   ON h.Project = p.Project
GO
