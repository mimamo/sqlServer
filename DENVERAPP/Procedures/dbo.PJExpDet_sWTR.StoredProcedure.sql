USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpDet_sWTR]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpDet_sWTR]
	@ParmEmployee varchar(10) AS
Exec("
	SELECT * from PjExpHdr H, PJExpDet D, PJProj P, PJEmploy E, PJPent T
		Where (H.status_1 = 'C' or H.status_1 = 'R')
		and H.DocNbr = D.DocNbr
		and D.Project = P.Project
		and P.Manager1 = '" + @ParmEmployee + "'
		and D.td_id14 = '1'
		and H.Employee = E.Employee
		and D.Project = T.Project
		and D.PJT_Entity = T.PJT_Entity
	Order by D.Project, D.Pjt_entity
")
GO
