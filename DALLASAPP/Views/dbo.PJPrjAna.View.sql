USE [DALLASAPP]
GO
/****** Object:  View [dbo].[PJPrjAna]    Script Date: 12/21/2015 13:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJPrjAna] AS

   SELECT 
      
      Project               = h.project,
      FiscYear              = h.fiscyear,
      PeriodPost            = h.periodpost,
      FiscPeriod            = h.fiscperiod,
      MTDHrs                = h.mtdhrs,
      MTDRev                = h.mtdrev,
      MTDRevAdj             = h.mtdrevadj,
      MTDLabor              = h.mtdlabor,
      MTDExp                = h.mtdexp,
      MTDMargin             = CAST((h.mtdrev + h.mtdrevadj - h.mtdlabor - h.mtdexp)AS DEC(28,2)),
      MTDMarginPct          = CAST(CASE WHEN (h.mtdrev + h.mtdrevadj) <> 0.00 THEN (h.mtdrev + h.mtdrevadj - h.mtdlabor - h.mtdexp)/(h.mtdrev + h.mtdrevadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      MTDRate               = CAST(CASE WHEN h.mtdhrs <> 0.00 THEN (h.mtdrev + h.mtdrevadj - h.mtdexp) / (h.mtdhrs)ELSE 0.00 END AS DEC(28,2)),
      MTDNLM                = CAST(CASE WHEN h.mtdlabor <> 0.00 THEN (h.mtdrev + h.mtdrevadj - h.mtdexp) / (h.mtdlabor)ELSE 0.00 END AS DEC(28,2)),
      YTDHrs                = h.ytdhrs,
      YTDRev                = h.ytdrev,
      YTDRevAdj             = h.ytdrevadj,
      YTDLabor              = h.ytdlabor,
      YTDExp                = h.ytdexp,
      YTDMargin             = CAST((h.ytdrev + h.ytdrevadj - h.ytdlabor - h.ytdexp)AS DEC(28,2)),
      YTDMarginPct          = CAST(CASE WHEN (h.ytdrev + h.ytdrevadj) <> 0.00 THEN (h.ytdrev + h.ytdrevadj - h.ytdlabor - h.ytdexp)/(h.ytdrev + h.ytdrevadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      YTDRate               = CAST(CASE WHEN h.ytdhrs <> 0.00 THEN (h.ytdrev + h.ytdrevadj - h.ytdexp) / (h.ytdhrs)ELSE 0.00 END AS DEC(28,2)),
      YTDNLM                = CAST(CASE WHEN h.ytdlabor <> 0.00 THEN (h.ytdrev + h.ytdrevadj - h.ytdexp) / (h.ytdlabor)ELSE 0.00 END AS DEC(28,2)),
      PTDHrs                = h.ptdhrs,
      PTDRev                = h.ptdrev,
      PTDRevAdj             = h.ptdrevadj,
      PTDLabor              = h.ptdlabor,
      PTDExp                = h.ptdexp,
      PTDMargin             = CAST((h.ptdrev + h.ptdrevadj - h.ptdlabor - h.ptdexp)AS DEC(28,2)),
      PTDMarginPct          = CAST(CASE WHEN (h.ptdrev + h.ptdrevadj) <> 0.00 THEN (h.ptdrev + h.ptdrevadj - h.ptdlabor - h.ptdexp)/(h.ptdrev + h.ptdrevadj) * 100 ELSE 0.00 END AS DEC(28,2)),
      PTDRate               = CAST(CASE WHEN h.ptdhrs <> 0.00 THEN (h.ptdrev + h.ptdrevadj - h.ptdexp) / (h.ptdhrs)ELSE 0.00 END AS DEC(28,2)),
      PTDNLM                = CAST(CASE WHEN h.ptdlabor <> 0.00 THEN (h.ptdrev + h.ptdrevadj - h.ptdexp) / (h.ptdlabor)ELSE 0.00 END AS DEC(28,2)),
      Manager1              = p.manager1,
      Manager2              = p.manager2
      
FROM PJprjana1 h JOIN PjProj p
                 ON h.Project = p.Project
GO
