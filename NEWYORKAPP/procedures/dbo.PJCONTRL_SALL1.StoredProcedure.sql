USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SALL1]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SALL1]  @parm1 varchar (2) , @parm2 varchar (30) , @parm3 varchar (30)   as
select * from PJCONTRL
where    control_type      LIKE @parm1
and    control_code      LIKE @parm2 + @parm3
order by control_type ,
control_code
GO
