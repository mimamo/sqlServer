USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSHDR_sPJGLSUBCury]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSHDR_sPJGLSUBCury]  @parm1 varchar (16) , @parm2 varchar (24) , @parm3 varchar (10) , @parm4 varchar (4) as
select * from PJBSHDR, PJPROJ
where
PJBSHDR.project  = PJPROJ.project
and PJPROJ.billcuryid = @parm4
and PJBSHDR.project like @parm1
and PJPROJ.gl_subacct like @parm2
and PJBSHDR.CpnyId = @parm3
order by PJBSHDR.project, PJBSHDR.schednbr
GO
