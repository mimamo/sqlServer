USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk1]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk1] @parm1 varchar (16) , @parm2 varchar (4)  as
select * from PJBILL, PJPTDROL, PJINVSEC
where pjbill.project = pjptdrol.project and
pjptdrol.acct  = pjinvsec.acct    and
pjbill.project_billwith = @parm1  and
pjinvsec.inv_format_cd  = @parm2
order by pjptdrol.project,
pjptdrol.acct
GO
