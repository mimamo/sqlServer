USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_WPTTaskID_PV]    Script Date: 12/21/2015 14:06:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_WPTTaskID_PV]
	
@Parm0 varchar(32), @Parm1 varchar(16), @ParmEmployee varchar(10),@alltasksflag char(1), @SortCol varchar(60) AS

        DECLARE @TaskCaption char(16)
       

	Select @TaskCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'TASK'

exec ("

select '" + @TaskCaption + "'=pjpent.PJT_Entity, Description=pjpent.PJT_Entity_Desc
from pjpent left outer join pjpentem on pjpent.project = pjpentem.project and pjpent.pjt_entity = pjpentem.pjt_entity 
where pjpent.status_pa = 'A' and pjpent.status_lb = 'A' 
and pjpent.PJT_Entity like '%" + @Parm0 + "%' 
and pjpent.project = '" + @Parm1 + "' 
and 

(pjpentem.employee = '" + @ParmEmployee + "' or '" + @alltasksflag + "' = 'Y')

group by pjpent.PJT_Entity,pjpent.PJT_Entity_Desc
order by " + @SortCol

)
GO
