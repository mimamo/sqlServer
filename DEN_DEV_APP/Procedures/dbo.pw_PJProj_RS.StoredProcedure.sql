USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJProj_RS]    Script Date: 12/21/2015 14:06:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJProj_RS]
	@Parm0 varchar(16) AS
exec("
	Select Project, project_desc, status_pa, status_lb, gl_subacct, cpnyid, labor_gl_acct, MSPInterface, status_18 from PJProj 
		where project = '" + @Parm0 + "'" 
)
GO
