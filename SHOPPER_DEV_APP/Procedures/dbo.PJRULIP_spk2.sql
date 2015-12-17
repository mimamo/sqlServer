USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULIP_spk2]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULIP_spk2] @parm1 varchar (16) ,@parm2 varchar (16) as
select *
from PJBILL, PJRULIP
	left outer join PJACCT
		on 	pjrulip.acct = pjacct.acct
where pjbill.project = @parm1 and
	pjrulip.bill_type_cd = pjbill.bill_type_cd and
	PJRULIP.acct = @parm2
GO
