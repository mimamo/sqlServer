USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[PJDetAna]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PJDetAna] as

select	
	a.project Project,
	a.task Task,
        a.period Period,
	a.date DocDate,
	a.docnbr DocNbr,
	a.srcacct SrcAcct,
	a.vendor Vendor,
	a.employee Employee,
	a.laborclass LaborClass,
	a.srcid SrcID,
	a.Hours,    
	a.Revenue,  
	a.RevAdj,   
	a.Labor,    
	a.Expense,  
        MTDMargin      = CAST((a.revenue + a.revadj - a.labor - a.expense)AS DEC(28,2)),
        MarginPct      = CAST(CASE WHEN (a.revenue + a.revadj) <> 0.00 THEN (a.revenue + a.revadj - a.labor - a.expense)/(a.revenue + a.revadj) * 100 ELSE 0.00 END AS DEC(28,2)),
        Rate           = CAST(CASE WHEN a.hours <> 0.00 THEN (a.revenue + a.revadj - a.expense) / (a.hours)ELSE 0.00 END AS DEC(28,2)),
        NLM            = CAST(CASE WHEN a.labor <> 0.00 THEN (a.revenue + a.revadj - a.expense) / (a.labor)ELSE 0.00 END AS DEC(28,2)),
        p.manager1 Manager1,
        p.manager2 Manager2
from PJDetAna1 a JOIN PjProj p
                   ON a.Project = p.Project
GO
