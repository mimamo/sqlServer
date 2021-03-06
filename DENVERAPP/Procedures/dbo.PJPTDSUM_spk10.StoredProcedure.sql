USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_spk10]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_spk10] @parm1 varchar (16) , @parm2 varchar (32) as
select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,
	pjacct.id1_sw,pjptdsum.act_amount,pjptdsum.eac_amount,
	pjptdsum.act_units,pjptdsum.eac_units
from pjacct
	left outer join pjptdsum 
		on pjacct.acct = pjptdsum.acct
where project = @parm1 and pjt_entity = @parm2
	and pjacct.ca_id20 = 'W'
order by pjacct.sort_num, pjacct.acct
select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,pjacct.id1_sw,
	pjptdsum.act_amount,pjptdsum.eac_amount,pjptdsum.act_units,pjptdsum.eac_units
from pjacct
	left outer join pjptdsum
		on pjacct.acct = pjptdsum.acct
where project = @parm1 and pjt_entity = @parm2
	and pjacct.ca_id20 = 'E'
order by pjacct.sort_num, pjacct.acct
select pjacct.ca_id20,pjacct.acct_desc,pjacct.acct,pjacct.id1_sw,
	pjptdsum.act_amount,pjptdsum.eac_amount,pjptdsum.act_units,pjptdsum.eac_units
from pjacct
	left outer join pjptdsum
		on pjacct.acct = pjptdsum.acct
where project = @parm1 and pjt_entity = @parm2
	and pjacct.ca_id20 = 'R'
order by pjacct.sort_num, pjacct.acct
GO
