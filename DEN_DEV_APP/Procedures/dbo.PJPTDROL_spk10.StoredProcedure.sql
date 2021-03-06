USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_spk10]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_spk10] @parm1 varchar (16) as
select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,pjacct.id1_sw,
	PJPTDROL.act_amount,PJPTDROL.eac_amount,PJPTDROL.act_units,PJPTDROL.eac_units
from pjacct
	left outer join PJPTDROL
		on pjacct.acct = PJPTDROL.acct
where project = @parm1 and pjacct.ca_id20 = 'W'
order by pjacct.sort_num, pjacct.acct

select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,pjacct.id1_sw,
	PJPTDROL.act_amount,PJPTDROL.eac_amount,PJPTDROL.act_units,PJPTDROL.eac_units
from pjacct
	left outer join PJPTDROL
		on pjacct.acct = PJPTDROL.acct
where project = @parm1 and pjacct.ca_id20 = 'E'
order by pjacct.sort_num, pjacct.acct

select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,pjacct.id1_sw,
	PJPTDROL.act_amount,PJPTDROL.eac_amount,PJPTDROL.act_units,PJPTDROL.eac_units
from pjacct
	left outer join PJPTDROL
		on pjacct.acct = PJPTDROL.acct
where project = @parm1 and pjacct.ca_id20 = 'R'
order by pjacct.sort_num, pjacct.acct
GO
