USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SALL]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SALL]  @parm1 varchar (2) , @parm2 varchar (30)   as
select * from PJCONTRL
where    control_type      LIKE @parm1
and    control_code      LIKE @parm2
order by control_type ,
control_code
GO
