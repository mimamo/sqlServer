USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk5]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk5] @parm1 varchar (16) , @parm2 varchar (16)  as
select * from pjbill, pjproj
where
pjbill.project = pjproj.project and
pjbill.project_billwith = @parm1   and
pjbill.project like @parm2
order by pjbill.project
GO
