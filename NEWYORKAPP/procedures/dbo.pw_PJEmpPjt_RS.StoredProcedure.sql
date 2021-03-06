USE [NEWYORKAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'pw_PJEmpPjt_RS'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pw_PJEmpPjt_RS]
GO

Create Procedure [dbo].[pw_PJEmpPjt_RS]
	@Parm0 varchar(10), 
	@Parm1 varchar(16), 
	@Parm2 varchar(10) , 
	@OuterJoinFlag bit  = 0 
	
AS 

/*******************************************************************************************************
*   NEWYORKAPP.dbo.pw_PJEmpPjt_RS 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute NEWYORKAPP.dbo.pw_PJEmpPjt_RS 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/


if (@OuterJoinFlag = 0)
	BEGIN
	exec("
	
		Select e.labor_class_cd, 
			c.code_value_desc, 
			c.data2 
		from pjemppjt e
		inner join pjcode c
			on e.labor_class_cd = c.code_value 
		where e.employee = '" + @Parm0 + "'
			and e.project = '" + @Parm1 + "'
			and e.effect_date <= '" + @Parm2 + "'				
			and c.code_type = 'LABC'
		order by effect_date desc"
		)
	END
else
	BEGIN

	exec("
	
		Select e.labor_class_cd, 
			c.code_value_desc, 
			c.data2 
		from pjemppjt e 
		left outer join pjcode c
			on e.labor_class_cd = c.code_value 
		where e.employee = '" + @Parm0 + "'
			and e.project = '" + @Parm1 + "'
			and e.effect_date <= '" + @Parm2 + "'				
			and c.code_type = 'LABC'
		order by effect_date desc"
		)
	END
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pw_PJEmpPjt_RS to BFGROUP
go

grant execute on pw_PJEmpPjt_RS to MSDSL
go

grant control on pw_PJEmpPjt_RS to MSDSL
go

grant execute on pw_PJEmpPjt_RS to MSDynamicsSL
go