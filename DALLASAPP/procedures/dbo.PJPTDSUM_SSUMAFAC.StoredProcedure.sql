USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_SSUMAFAC]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJPTDSUM_SSUMAFAC] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (2) , @parm4 varchar (1)  as
select SUM ( pjptdsum.act_amount ),
SUM ( pjptdsum.act_units ),
SUM ( pjptdsum.com_amount ),
SUM ( pjptdsum.com_units ),
SUM ( pjptdsum.eac_amount ),
SUM ( pjptdsum.eac_units ),
SUM ( pjptdsum.total_budget_amount ),
SUM ( pjptdsum.total_budget_units ),
SUM ( pjptdsum.fac_amount ),
SUM ( pjptdsum.fac_units )
from pjptdsum, pjacct
where pjptdsum.project = @parm1 and
pjptdsum.pjt_entity =  @parm2 and
pjptdsum.acct =  pjacct.acct  and
pjacct.acct_type like @parm3 and
pjacct.id3_sw like @parm4
GO
