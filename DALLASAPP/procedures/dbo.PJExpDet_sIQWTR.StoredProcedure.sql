USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpDet_sIQWTR]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpDet_sIQWTR]
	@ParmEmployee varchar(10), @parmField varchar(20), @parmValue varchar(50) AS
Exec("

		SELECT * from PjExpHdr H, PJExpDet D, PJProj P, PJEmploy E, PJPent T
			Where (H.status_1 = 'C' or H.status_1 = 'R')
			and H.DocNbr = D.DocNbr
			and D.td_id14 = '1'
			and H.Employee = E.Employee
			and D.Project in (Select project from PJProj where " + @parmField + " like '" + @parmValue + "%')
			and D.Project = P.Project
			and D.Project = T.Project
			and D.PJT_Entity = T.PJT_Entity
			Order by D.Project, D.Pjt_entity

")
GO
