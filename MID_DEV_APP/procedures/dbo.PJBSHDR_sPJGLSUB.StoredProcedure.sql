USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSHDR_sPJGLSUB]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSHDR_sPJGLSUB]  @parm1 varchar (16) , @parm2 varchar (24) , @parm3 varchar (10) as
select * from PJBSHDR, PJPROJ
where    PJBSHDR.project  = PJPROJ.project
and PJBSHDR.project like @parm1
and PJPROJ.gl_subacct like @parm2
and PJBSHDR.CpnyId = @parm3
order by PJBSHDR.project, PJBSHDR.schednbr
GO
