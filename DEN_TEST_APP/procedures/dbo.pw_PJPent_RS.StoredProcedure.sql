USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJPent_RS]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJPent_RS]
	@Parm0 varchar(16), @Parm1 varchar(32),@ParmEmployee varchar(10),@alltasksflag char(1) AS
exec("

	Select PJPent.pjt_entity_desc, PJPent.status_pa, PJPent.status_lb, PJPent.PE_ID01, X.PE_ID23
		from  PJPentEx X, PJPent left outer join pjpentem on pjpent.project = pjpentem.project 
                and pjpent.pjt_entity = pjpentem.pjt_entity 
		where (pjpentem.employee = '" + @ParmEmployee + "' or '" + @alltasksflag + "' = 'Y')
                
                and PJPent.project = '" + @Parm0 + "'
		and PJPent.Pjt_Entity = '" + @Parm1 + "'
		and PJPent.Project = X.Project
		and PJPent.Pjt_Entity = X.Pjt_Entity "
)
GO
