USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_swipPTC]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_swipPTC] @parm1 varchar (10)  as
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
		on	pjinvdet.acct = pjacct.acct
Where pjinvdet.draft_num = @PARM1 and
	pjinvdet.li_type in ('I','O') and
	pjinvdet.entry_type <> 'A'
order by pjinvdet.project,
	pjinvdet.pjt_entity,
	pjinvdet.acct,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
