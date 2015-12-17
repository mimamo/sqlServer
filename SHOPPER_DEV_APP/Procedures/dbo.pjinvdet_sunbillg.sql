USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sunbillg]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sunbillg] @parm1 varchar (16) , @parm2 smalldatetime , @parm3 varchar (4)  as
select  pjinvdet.*,
	pjpent.*,
	pjproj.*,
	pjemploy.employee, pjemploy.emp_name, pjinvdet.in_id15,
	pjinvdet.in_id16, pjinvdet.in_id17, pjpentex.pe_id11,
	pjpentex.pe_id15
From    pjinvdet
	left outer join pjemploy
		on 	pjinvdet.employee = pjemploy.employee
	, pjpent, pjproj, pjpentex
Where pjinvdet.project_billwith = @PARM1 and
	pjinvdet.draft_num = ''  and
	pjinvdet.hold_status <> 'PG' and
	pjinvdet.source_trx_date <= @PARM2 and
	pjinvdet.project = pjproj.project and
	pjinvdet.project = pjpent.project and
	pjinvdet.pjt_entity = pjpent.pjt_entity and
	pjinvdet.project = pjpentex.project and
	pjinvdet.pjt_entity = pjpentex.pjt_entity and
	pjpentex.pe_id15 = @parm3
order by pjinvdet.source_trx_id
GO
