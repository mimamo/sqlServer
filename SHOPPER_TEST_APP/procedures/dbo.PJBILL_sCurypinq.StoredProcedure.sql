USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_sCurypinq]    Script Date: 12/21/2015 16:07:12 ******/
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
