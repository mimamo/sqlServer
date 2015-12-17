USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_swipGPTC]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_swipGPTC] @parm1 varchar (10), @parm2 varchar (16) , @parm3 smalldatetime, @parm4 varchar (4)        as
select pjinvdet.*,
	pjpent.*,
	pjproj.*,
	pjemploy.employee, pjemploy.emp_name,
	vendor.vendid, vendor.name, pjacct.ca_id03
From pjinvdet
	left outer join pjpent
		on pjinvdet.project = pjpent.project
		and pjinvdet.pjt_entity = pjpent.pjt_entity
	left outer join pjproj
		on pjinvdet.project = pjproj.project
	left outer join pjemploy
		on pjinvdet.employee = pjemploy.employee
	left outer join vendor
		on pjinvdet.vendor_num = vendor.vendid
	left outer join pjacct
		on pjinvdet.acct = pjacct.acct
	, pjpentex
Where pjinvdet.project = pjpentex.project and
	pjinvdet.pjt_entity = pjpentex.pjt_entity and
	pjpentex.pe_id15 like @parm4 and
	pjinvdet.entry_type <> 'A' and
	(pjinvdet.draft_num = @PARM1 and pjinvdet.draft_num <> '' and
	pjinvdet.li_type in ('I','O'))
UNION
select pjinvdet.*,
	pjpent.*,
	pjproj.*,
	pjemploy.employee, pjemploy.emp_name,
	vendor.vendid, vendor.name, pjacct.ca_id03
From pjinvdet
	left outer join pjpent
		on pjinvdet.project = pjpent.project
		and pjinvdet.pjt_entity = pjpent.pjt_entity
	left outer join pjproj
		on pjinvdet.project = pjproj.project
	left outer join pjemploy
		on pjinvdet.employee = pjemploy.employee
	left outer join vendor
		on pjinvdet.vendor_num = vendor.vendid
	left outer join pjacct
		on pjinvdet.acct = pjacct.acct
	, pjpentex
Where pjinvdet.project = pjpentex.project and
	pjinvdet.pjt_entity = pjpentex.pjt_entity and
	pjpentex.pe_id15 like @parm4 and
	pjinvdet.entry_type <> 'A' and
	(pjinvdet.project_billwith = @PARM2 and
	pjinvdet.draft_num = ''  and
	pjinvdet.hold_status <> 'PG' and
	pjinvdet.source_trx_date <= @PARM3)
order by pjinvdet.project,
	pjinvdet.pjt_entity,
	pjinvdet.acct,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
