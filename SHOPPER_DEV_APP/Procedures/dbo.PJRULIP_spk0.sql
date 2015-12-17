USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULIP_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULIP_spk0] @parm1 varchar (4) , @parm2 varchar (16) as
select *
from PJRULIP
	left outer join PJACCT
		on PJRULIP.acct = PJACCT.acct
	left outer join ACCOUNT A
		on pjrulip.gl_acct = a.acct
	left outer join ACCOUNT B
		on pjrulip.adj_gl_acct = b.acct
	left outer join ACCOUNT C
		on pjrulip.credit_gl_acct = c.acct
	left outer join ACCOUNT D
		on pjrulip.debit_gl_acct = d.acct
where PJRULIP.bill_type_cd = @parm1 and
	PJRULIP.acct like @parm2
order by PJRULIP.bill_type_cd, PJRULIP.acct
GO
