USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEX_srev]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEX_srev]  @parm1 varchar (16), @parm2 varchar (24) , @parm3 varchar (10) as
select * from PJPROJEX, PJPROJ
where
pjproj.project like @parm1 and
pjproj.gl_subacct like @parm2 and
pjproj.cpnyid = @parm3 and
(pjproj.status_pa = 'A' or pjproj.status_pa = 'I') and
pjproj.project = pjprojex.project and
pjprojex.rev_flag = 'Y'
order by pjproj.project
GO
