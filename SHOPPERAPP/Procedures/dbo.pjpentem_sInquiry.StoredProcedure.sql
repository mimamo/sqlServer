USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjpentem_sInquiry]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- 04/20/04 BK DE# 235214 PCL# 1946.  Assignment Inquiry should NOT filter if budget/actual amount/units all = 0
-- unless specific option chosen
CREATE Procedure [dbo].[pjpentem_sInquiry] @ParmEmp varchar(10), @ParmSel varchar(1) AS

IF @ParmSel = 'A'                          -- All Pjpentem records
    BEGIN
	Select pjpentem.project,
	       pjpentem.pjt_entity,
	       pjpent.pjt_entity_desc,
	       pjpentem.subtask_name,
	       pjpentem.date_start,
	       pjpentem.date_end,
	       pjpent.start_date,
	       pjpent.end_date,
	       pjproj.start_date,
	       pjproj.end_date,
	       pjpentem.Actual_units,
	       pjpentem.Budget_units,
	       pjpentem.Actual_amt,
	       pjpentem.Budget_amt,
	       pjpentem.Revenue_amt,
	       pjpentem.Revadj_amt,
	       pjpentem.comment
	from pjpentem

	INNER JOIN PJPent
	ON PJPentem.Project = Pjpent.Project and PJPentem.PJT_Entity = Pjpent.PJT_Entity

	INNER JOIN PJProj
	ON PJPentem.Project = Pjproj.Project

	where
	Pjpentem.employee = @ParmEmp

	order by PJPentem.Project, PJPentem.PJT_Entity, pjpentem.subtask_name
    END                                   -- IF @ParmSel = 'A' (All Pjpentem records)

IF @ParmSel = 'C'                         -- Pjpentem records w/Actuals charged
    BEGIN
	Select pjpentem.project,
	       pjpentem.pjt_entity,
	       pjpent.pjt_entity_desc,
	       pjpentem.subtask_name,
	       pjpentem.date_start,
	       pjpentem.date_end,
	       pjpent.start_date,
	       pjpent.end_date,
	       pjproj.start_date,
	       pjproj.end_date,
	       pjpentem.Actual_units,
	       pjpentem.Budget_units,
	       pjpentem.Actual_amt,
	       pjpentem.Budget_amt,
	       pjpentem.Revenue_amt,
	       pjpentem.Revadj_amt,
	       pjpentem.comment
	 from pjpentem

	INNER JOIN PJPent
	ON PJPentem.Project = Pjpent.Project and PJPentem.PJT_Entity = Pjpent.PJT_Entity

	INNER JOIN PJProj
	ON PJPentem.Project = Pjproj.Project

	where
	Pjpentem.employee = @ParmEmp And
	((pjpentem.Actual_amt <> 0) or (pjpentem.Actual_units <> 0))

	order by PJPentem.Project, PJPentem.PJT_Entity, pjpentem.subtask_name

    END                                   -- IF @ParmSel = 'C' (Pjpentem records w/Actuals charged)

IF @ParmSel = 'N'                         -- Pjpentem records with NO Actuals charged
    BEGIN
	Select pjpentem.project,
	       pjpentem.pjt_entity,
	       pjpent.pjt_entity_desc,
	       pjpentem.subtask_name,
	       pjpentem.date_start,
	       pjpentem.date_end,
	       pjpent.start_date,
	       pjpent.end_date,
	       pjproj.start_date,
	       pjproj.end_date,
	       pjpentem.Actual_units,
	       pjpentem.Budget_units,
	       pjpentem.Actual_amt,
	       pjpentem.Budget_amt,
	       pjpentem.Revenue_amt,
	       pjpentem.Revadj_amt,
	       pjpentem.comment
	 from pjpentem

	INNER JOIN PJPent
	ON PJPentem.Project = Pjpent.Project and PJPentem.PJT_Entity = Pjpent.PJT_Entity

	INNER JOIN PJProj
	ON PJPentem.Project = Pjproj.Project

	where
	Pjpentem.employee = @ParmEmp And
	(pjpentem.Actual_amt = 0 and pjpentem.Actual_units = 0)

	order by PJPentem.Project, PJPentem.PJT_Entity, pjpentem.subtask_name
    END                                   -- IF @ParmSel = 'N' (Pjpentem records with NO Actuals charged)
GO
