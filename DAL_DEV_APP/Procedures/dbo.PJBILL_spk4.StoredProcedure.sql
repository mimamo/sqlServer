USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk4]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk4] @parm1 varchar (16)  as
select * from PJBILL, PJPROJ
where pjbill.project = pjproj.project and
pjbill.project Like @parm1 and
pjbill.project_billWith = pjbill.project and
pjproj.status_pa = 'A'
order by pjbill.project
GO
