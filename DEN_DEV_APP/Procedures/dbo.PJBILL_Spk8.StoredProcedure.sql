USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_Spk8]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJBILL_Spk8] @parm1 varchar (24) , @parm2 varchar (10) , @parm3 varchar (2) , @parm4 varchar (16) , @parm5 smalldatetime  as
SELECT pjbill.*, pjproj.*, pjinvdet.*, pjpent.pjt_entity, pjpent.fips_num,
pjpentex.pe_id11, pjpentex.pe_id15
from
pjbill, pjproj,  pjinvdet, pjpent, pjpentex
WHERE
pjbill.project_billwith = pjbill.Project and
pjbill.project = pjproj.Project and
pjbill.project = pjinvdet.project_billwith and
pjproj.gl_Subacct Like @parm1 and
pjbill.Biller Like @parm2 and
pjbill.billings_cycle_cd Like @parm3 and
pjinvdet.project_billwith Like @parm4 and
pjinvdet.source_trx_date <= @parm5 and
pjinvdet.hold_status = 'A ' and
pjinvdet.bill_status =  'U' and
pjinvdet.project = pjpent.project and
pjinvdet.pjt_entity = pjpent.pjt_entity and
pjinvdet.project = pjpentex.project and
pjinvdet.pjt_entity = pjpentex.pjt_entity
Order by
pjinvdet.project_billwith
GO
