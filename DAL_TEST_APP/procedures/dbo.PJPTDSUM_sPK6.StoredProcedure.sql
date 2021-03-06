USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sPK6]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_sPK6] @parm1 varchar (16) as
select *
from PJPTDSUM
	left outer join PJPENT
		on 	pjptdsum.project = pjpent.project
		and pjptdsum.pjt_entity = pjpent.pjt_entity
	, PJACCT
where
	pjptdsum.project = @parm1 and
	pjptdsum.acct = pjacct.acct AND
	(pjacct.acct_type = 'EX' or pjacct.acct_type = 'RV')
order by pjptdsum.pjt_entity,pjacct.sort_num
GO
