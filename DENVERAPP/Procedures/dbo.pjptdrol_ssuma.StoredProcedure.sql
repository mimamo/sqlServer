USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_ssuma]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_ssuma] @parm1 varchar (16) , @parm2 varchar (2) , @parm3 varchar (1)  as
select SUM ( pjptdrol.act_amount ),
SUM ( pjptdrol.act_units ),
SUM ( pjptdrol.com_amount ),
SUM ( pjptdrol.com_units ),
SUM ( pjptdrol.eac_amount ),
SUM ( pjptdrol.eac_units ),
SUM ( pjptdrol.total_budget_amount ),
SUM ( pjptdrol.total_budget_units )
from pjptdrol, pjacct
where pjptdrol.project = @parm1 and
pjptdrol.acct =  pjacct.acct  and
pjacct.acct_type like @parm2 and
pjacct.id3_sw like @parm3
GO
