USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabDet_sWTR]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabDet_sWTR]
	@ParmEmployee varchar(10) AS
Exec("
	SELECT *, D.labor_class_cd as DetLabor_class_cd from PjLabHdr H, PJLabDet D, PJProj P, PJEmploy E, PJPent T
		Where (H.le_status = 'C' or H.le_status = 'R')
			and H.DocNbr = D.DocNbr
			and D.Project = P.Project
			and P.Manager1 = '" + @ParmEmployee + "'
			and D.ld_id17 = '1'
			and H.Employee = E.Employee
			and D.Project = T.Project
			and D.PJT_Entity = T.PJT_Entity
		Order by D.Project, D.Pjt_entity
")
GO
