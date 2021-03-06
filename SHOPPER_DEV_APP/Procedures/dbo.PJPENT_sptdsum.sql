USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sptdsum]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sptdsum] @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (32)   as
select *
from PJPENT
	left outer join PJEMPLOY
		on PJPENT.manager1 = PJEMPLOY.employee
	left outer join PJPENTEX
		on PJPENT.project = PJPENTEX.project
		and PJPENT.pjt_entity = PJPENTEX.pjt_entity
	left outer join pjptdsum
		on pjpent.project = pjptdsum.project
		and pjpent.pjt_entity = pjptdsum.pjt_entity
where pjpent.project = @parm1
	and pjpent.pjt_entity like @parm3
	and	pjptdsum.acct = @parm2
order by pjpent.project, pjpent.pjt_entity
GO
