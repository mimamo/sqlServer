USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_scontamt]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_scontamt] @parm1 varchar (16) , @parm2 varchar (16)   as
	select
sum(r.eac_amount ), sum(r.total_budget_amount)
	from 	pjproj p, pjptdrol r
	where	p.contract =  @parm1
	     and	p.project = r.project
	     and	r.acct =  @parm2
GO
