USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_spk1]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_spk1] @parm1 varchar (16), @parm2 varchar (32)  as
select *
from PJPENTEM
	left outer join PJEMPLOY
		on PJPENTEM.employee = pjemploy.employee
where PJPENTEM.project = @parm1 and
      PJPENTEM.pjt_entity = @parm2
order by PJPENTEM.employee
GO
