USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_stri3]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_stri3] @parm1 varchar (15) , @parm2 varchar (16) , @parm3 varchar (10) , @parm4 varchar (15) , @parm5 varchar (32) ,
@parm6 varchar (16) , @parm7 varchar (1) , @parm8 smalldatetime , @parm9 smalldatetime   as
select pjinvdet.*, pjproj.*, pjinvhdr.*
from pjinvdet
	left outer join pjinvhdr
		on pjinvdet.draft_num = pjinvhdr.draft_num
	, pjproj
Where pjinvdet.employee like @PARM3 and
	pjinvdet.project = pjproj.project and
	pjproj.customer like @PARM1 and
	pjinvdet.project like @PARM2 and
	pjinvdet.vendor_num like @PARM4 and
	pjinvdet.pjt_entity like @PARM5 and
	pjinvdet.acct like @PARM6 and
	pjinvdet.bill_status like @PARM7 and
	pjinvdet.li_type <> 'S' and
	pjinvdet.source_trx_date >= @parm8 and
	pjinvdet.source_trx_date <= @parm9
order by pjinvdet.bill_status,
	pjinvdet.source_trx_date,
	pjinvdet.project,
	pjinvdet.pjt_entity,
	pjinvdet.acct
GO
