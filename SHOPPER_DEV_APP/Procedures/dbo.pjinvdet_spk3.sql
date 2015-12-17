USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk3]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk3] @parm1 varchar (16)  as
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
Where pjinvdet.project_billwith = @PARM1 and
	pjinvdet.draft_num = '0000000000'
order by pjinvdet.source_trx_id
GO
