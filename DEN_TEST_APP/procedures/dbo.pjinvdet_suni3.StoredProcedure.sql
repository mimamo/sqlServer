USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_suni3]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_suni3] @parm1 varchar (16)  as
select *
from pjinvdet
	left outer join pjemploy
		on 	pjinvdet.employee = pjemploy.employee
Where pjinvdet.project_billwith = @PARM1 and
	pjinvdet.bill_status = 'U'
order by pjinvdet.project,
	pjinvdet.pjt_entity,
	pjinvdet.acct,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
