USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_ssumra]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_ssumra] @parm1 varchar (16) as
select SUM ( pjptdrol.act_amount ),
SUM ( pjptdrol.act_units )
from pjptdrol, pjacct
where pjptdrol.project = @parm1 and
pjptdrol.acct =  pjacct.acct  and
(pjacct.acct_type = 'RV' or
pjacct.acct_type = 'AS')
group by pjptdrol.project
order by pjptdrol.project
GO
