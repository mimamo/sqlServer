USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabDet_sIQWTR]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabDet_sIQWTR]
	@ParmEmployee varchar(10), @parmField varchar(20), @parmValue varchar(50) AS
Exec("
		SELECT *, D.labor_class_cd as DetLabor_class_cd from PjLabHdr H, PJLabDet D, PJProj P, PJEmploy E, PJPent T
			Where (H.le_status = 'C' or H.le_status = 'R')
			and H.DocNbr = D.DocNbr
			and D.ld_id17 = '1'
			and H.Employee = E.Employee
			and D.Project in (Select project from PJProj where " + @parmField + " like '" + @parmValue + "%')
			and D.Project = P.Project
			and D.Project = T.Project
			and D.PJT_Entity = T.PJT_Entity
		Order by D.Project, D.Pjt_entity


")
GO
