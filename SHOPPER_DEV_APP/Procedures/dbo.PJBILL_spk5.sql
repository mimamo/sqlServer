USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk5]    Script Date: 12/16/2015 15:55:26 ******/
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
