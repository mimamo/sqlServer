USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBMIT_SANALYZE]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBMIT_SANALYZE] @parm1 varchar (16) , @parm2 varchar (16) as
select *
from PJSUBMIT
	left outer join PJEMPLOY
		on pjsubmit.employee = pjemploy.employee
where project = @parm1 and
	subcontract = @parm2 and
	status1 = 'O'
order by project,
	subcontract,
	submitnbr
GO
