USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_spk9]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_spk9] @parm1 varchar (16) , @parm2 varchar (16)  as
select SUM ( pjptdrol.act_amount ),
SUM ( pjptdrol.act_units )
from pjbill, pjptdrol
where pjbill.project_billwith = @parm1 and
pjptdrol.project = pjbill.project and
pjptdrol.acct =  @parm2
GO
