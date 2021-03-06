USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_srules]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_srules] @parm1 varchar (16)  as
select pjbill.project,
       pjbill.project_billwith,
       pjbill.bill_type_cd,
       pjrules.bill_type_cd,
       pjrules.acct,
       pjrules.li_type
from   PJBILL, PJRULES
where  pjbill.project = @parm1 and
       pjbill.bill_type_cd = pjrules.bill_type_cd
order by pjbill.project
GO
