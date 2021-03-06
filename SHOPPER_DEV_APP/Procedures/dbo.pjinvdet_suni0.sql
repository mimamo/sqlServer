USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_suni0]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_suni0] @parm1 varchar (16)  as
select *
from pjinvdet
	left outer join pjemploy
		on 	pjinvdet.employee = pjemploy.employee
Where pjinvdet.project_billwith = @PARM1 and
	pjinvdet.bill_status = 'U'
order by pjinvdet.acct,
	pjinvdet.labor_class_cd,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
