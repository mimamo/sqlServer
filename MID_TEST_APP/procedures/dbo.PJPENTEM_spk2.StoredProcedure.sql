USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_spk2]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_spk2] @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (10)  as
select *
from PJPENTEM
	left outer join PJEMPLOY
		on PJPENTEM.employee = pjemploy.employee
where PJPENTEM.project = @parm1 and
      PJPENTEM.pjt_entity = @parm2 and
	  PJPENTEM.employee like @parm3
order by PJPENTEM.project, PJPENTEM.pjt_entity, PJPENTEM.employee, PJPENTEM.SubTask_Name
GO
