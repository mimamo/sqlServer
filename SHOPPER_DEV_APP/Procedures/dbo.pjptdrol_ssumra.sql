USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_ssumra]    Script Date: 12/16/2015 15:55:28 ******/
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
