USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk3]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk3] @parm1 varchar (16)  as
select
pjbill.project,
pjbill.project_billwith,
pjproj.project,
pjproj.project_desc,
pjproj.status_pa
from
PJBILL,
PJPROJ
where pjbill.project = pjproj.project and
pjbill.project Like @parm1 and
pjbill.project_billWith =  ' ' and
pjproj.status_pa = 'A'
order by pjbill.project
GO
