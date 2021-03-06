USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_PJEmpPjt_RS]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_PJEmpPjt_RS]
	@Parm0 varchar(10), @Parm1 varchar(16), @Parm2 varchar(10) , @OuterJoinFlag bit  = 0 AS

if (@OuterJoinFlag = 0)
	BEGIN
	exec("
	
		Select e.labor_class_cd, c.code_value_desc, c.data2 from pjemppjt e, pjcode c
			where e.employee = '" + @Parm0 + "'
				and e.project = '" + @Parm1 + "'
				and e.effect_date <= '" + @Parm2 + "'
				and e.labor_class_cd = c.code_value and c.code_type = 'LABC'
				order by effect_date desc"
		)
	END
else
	BEGIN

	exec("
	
		Select e.labor_class_cd, c.code_value_desc, c.data2 from pjemppjt e, pjcode c
			where e.employee = '" + @Parm0 + "'
				and e.project = '" + @Parm1 + "'
				and e.effect_date <= '" + @Parm2 + "'
				and e.labor_class_cd *= c.code_value and c.code_type = 'LABC'
				order by effect_date desc"
		)
	END
GO
