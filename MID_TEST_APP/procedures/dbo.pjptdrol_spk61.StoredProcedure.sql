USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjptdrol_spk61]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjptdrol_spk61] @parm1 varchar (16) , @parm2 varchar (16)  as
select SUM ( pjptdrol.eac_amount ),
SUM ( pjptdrol.eac_units )
from pjbill, pjptdrol
where pjbill.project_billwith = @parm1 and
pjptdrol.project = pjbill.project and
pjptdrol.acct = @parm2
GO
