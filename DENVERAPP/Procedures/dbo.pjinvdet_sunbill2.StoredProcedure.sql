USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sunbill2]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sunbill2] @parm1 varchar (16)  as
select  pjinvdet.source_trx_date,
pjinvdet.amount,
pjinvdet.project_billwith
From    pjinvdet
Where
pjinvdet.project_billwith = @PARM1 and
pjinvdet.draft_num = ''  and
pjinvdet.hold_status <> 'PG'
order by
pjinvdet.source_trx_id
GO
