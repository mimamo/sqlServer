USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sdr0]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sdr0] @parm1 varchar (10)  as
select *
From pjinvdet
	left outer join pjemploy
		on pjinvdet.employee = pjemploy.employee
Where pjinvdet.draft_num = @PARM1 and
	pjinvdet.li_type <> 'S'
order by pjinvdet.acct,
	pjinvdet.labor_class_cd,
	pjinvdet.employee,
	pjinvdet.vendor_num,
	pjinvdet.source_trx_date
GO
