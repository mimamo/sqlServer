USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_sCheckBW]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_sCheckBW] @parm1 varchar (16)  as
select PJBILL.* from PJBILL, PJPROJ
where
pjbill.project_billwith = @parm1 and
pjbill.project_billwith <> pjbill.project and
pjbill.project = pjproj.project and
pjproj.status_pa <> 'D'
GO
