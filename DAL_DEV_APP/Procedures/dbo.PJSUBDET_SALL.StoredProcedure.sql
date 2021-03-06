USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_SALL]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_SALL] @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4) as
select *
from PJSUBDET
	left outer join PJ_Account
		on PJSUBDET.gl_Acct = Pj_Account.gl_Acct
where PJSUBDET.project = @parm1 and
	PJSUBDET.subcontract = @parm2 and
	PJSUBDET.sub_line_item LIKE @parm3
order by PJSUBDET.project, PJSUBDET.subcontract, PJSUBDET.sub_line_item
GO
