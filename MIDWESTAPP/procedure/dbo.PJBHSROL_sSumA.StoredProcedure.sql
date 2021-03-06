USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBHSROL_sSumA]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBHSROL_sSumA]  @parm1 varchar (16) , @parm2 varchar (2) , @parm3 varchar (1) , @parm4 varchar (6)   as
select sum (total_budget_amount), sum (total_budget_units), sum (eac_amount), sum (eac_units), sum (fac_amount), sum (fac_units)
from pjbhsrol, pjacct
where pjbhsrol.project = @parm1 and
pjbhsrol.fiscalno <= @parm4 and
pjbhsrol.acct =  pjacct.acct  and
pjacct.acct_type like @parm2 and
pjacct.id3_sw like @parm3
GO
