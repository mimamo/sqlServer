USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_sCurypinq]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_sCurypinq] @parm1 varchar (16)  as
select * from PJBILL, PJPROJ
where
pjbill.project = pjproj.project and
pjbill.project Like @parm1 and
pjbill.project_billwith = pjbill.project and
pjproj.status_pa = 'A'
order by pjbill.project
GO
