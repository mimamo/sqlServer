USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBMIT_SENTRY]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBMIT_SENTRY] @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (10) as
select *
from PJSUBMIT
	left outer join PJEMPLOY
		on pjsubmit.employee = pjemploy.employee
where project = @parm1 and
	subcontract = @parm2 and
	submitnbr like @parm3
order by project,
	subcontract,
	submitnbr
GO
