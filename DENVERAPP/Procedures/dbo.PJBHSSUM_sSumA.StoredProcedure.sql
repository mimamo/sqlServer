USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBHSSUM_sSumA]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJBHSSUM_sSumA]  @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (2) , @parm4 varchar (1) , @parm5 varchar (6)   as
select sum (total_budget_amount), sum (total_budget_units), sum (eac_amount), sum (eac_units), sum (fac_amount), sum (fac_units)
from pjbhssum, pjacct
where pjbhssum.project = @parm1 and
pjbhssum.pjt_entity =  @parm2 and
pjbhssum.fiscalno <= @parm5 and
pjbhssum.acct =  pjacct.acct  and
pjacct.acct_type like @parm3 and
pjacct.id3_sw like @parm4
GO
