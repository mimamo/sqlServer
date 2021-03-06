USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_sdllEAC]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_sdllEAC] @parm1 varchar (16) , @parm2 varchar (16)   as
select  pjbill.project_billwith,  pjptdrol.acct, sum(pjptdrol.eac_amount)
from    pjbill, pjptdrol
where   pjbill.project_billwith = @parm1
and        pjbill.project = pjptdrol.project
and        pjptdrol.acct = @parm2
group by        pjbill.project_billwith, pjptdrol.acct
order by        pjbill.project_billwith, pjptdrol.acct
GO
