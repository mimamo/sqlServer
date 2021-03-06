USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_swebunbill]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_swebunbill] @parm1 varchar (16) , @parm2 varchar (10) , @parm3 varchar (10) as

select  pjinvdet.*,
pjinvhdr.invoice_num, pjinvhdr.invoice_date,
pjemploy.emp_name

From    pjinvdet, pjinvhdr, pjemploy

Where
(pjinvdet.project = @PARM1 or pjinvdet.project_billwith = @PARM1)
and
pjinvdet.bill_status IN ('U', 'S') and
pjinvdet.source_trx_date >= @PARM2 and
pjinvdet.source_trx_date <= @PARM3 and
pjinvdet.employee *= pjemploy.employee   and
pjinvdet.draft_num *= pjinvhdr.draft_num  

order by
pjinvdet.source_trx_id
GO
