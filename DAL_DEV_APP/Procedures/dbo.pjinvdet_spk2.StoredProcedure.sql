USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk2]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk2] @parm1 varchar (10)  as
select  pjinvdet.*,
	pjpent.*,
	pjproj.*,
	pjemploy.employee, pjemploy.emp_name
From pjinvdet
	left outer join pjpent
		on pjinvdet.project = pjpent.project
		and pjinvdet.pjt_entity = pjpent.pjt_entity
	left outer join pjproj
		on pjinvdet.project = pjproj.project
	left outer join pjemploy
		on pjinvdet.employee = pjemploy.employee
Where pjinvdet.draft_num = @PARM1 and
	pjinvdet.li_type <> 'S'
order by pjinvdet.draft_num, pjinvdet.source_trx_date
GO
