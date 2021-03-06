USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sunbilld]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sunbilld] @parm1 varchar (16) , @parm2 smalldatetime  as
select  pjinvdet.*,
	pjpent.*,
	pjproj.*,
	pjemploy.employee, pjemploy.emp_name, pjinvdet.in_id15,
	pjinvdet.in_id16, pjinvdet.in_id17
From    pjinvdet
	left outer join pjpent
		on 	pjinvdet.project = pjpent.project
		and pjinvdet.pjt_entity = pjpent.pjt_entity
	left outer join pjproj
		on pjinvdet.project = pjproj.project
	left outer join pjemploy
		on 	pjinvdet.employee = pjemploy.employee
Where pjinvdet.project_billwith = @PARM1 and
	pjinvdet.draft_num = ''  and
	pjinvdet.hold_status <> 'PG' and
	pjinvdet.source_trx_date <= @PARM2
order by pjinvdet.source_trx_id
GO
