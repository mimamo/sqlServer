USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJMX_SPK0]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJMX_SPK0]  @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (16) as
select  * from PJPROJMX
where    project     =  @parm1 and
         pjt_entity  like  @parm2 and
	   acct	   like @parm3
order by project, pjt_entity, acct
GO
