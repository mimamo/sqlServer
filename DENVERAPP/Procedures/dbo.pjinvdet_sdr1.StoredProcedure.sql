USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sdr1]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sdr1] @parm1 varchar (10)  as
select *
from pjinvdet
	left outer join pjemploy
		on pjinvdet.employee = pjemploy.employee
Where pjinvdet.draft_num = @PARM1  and
	pjinvdet.li_type <> 'S'
order by pjinvdet.acct,
	pjinvdet.project,
	pjinvdet.pjt_entity,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
