USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spinq]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spinq] @parm1 varchar (16)  as
select * from PJBILL, PJPROJ
where pjbill.project = pjproj.project and
pjbill.project Like @parm1 and
pjbill.project_billwith = pjbill.project
order by pjbill.project
GO
