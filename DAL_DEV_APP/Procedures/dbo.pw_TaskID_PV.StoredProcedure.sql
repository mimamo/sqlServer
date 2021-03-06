USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_TaskID_PV]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_TaskID_PV] 
	@Parm0 varchar(32), @Parm1 varchar(16), @ParmEmployee varchar(10), @SortCol varchar(60) AS


	DECLARE @TaskCaption char(16)

	Select @TaskCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'TASK'

	exec("
	
	Select '" + @TaskCaption + "'=PJT_Entity , Description=PJT_Entity_Desc 
	from PJPENT 
	where PJT_Entity like '%" + @Parm0 + "%' and 
		Project = '" + @Parm1 + "' and Status_PA = 'A'
	Order by " + @SortCol  
)
GO
