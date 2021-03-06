USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_spk60]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_spk60] @parm1 varchar (16)  as
select SUM ( pjptdrol.eac_amount ),
SUM ( pjptdrol.eac_units )
from pjbill, pjptdrol, pjacct
where pjbill.project_billwith = @parm1 and
pjptdrol.project = pjbill.project and
pjacct.acct =  pjptdrol.acct  and
pjacct.acct_type = 'EX'
GO
