USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_SPK4]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_SPK4] @parm1 varchar (16), @parm2 varchar (32),  @parm3 varchar (16), @parm4 varchar (50)  as
select * from PJPENTEM
where project like @parm1
and pjt_entity  like  @parm2
and employee = @parm3
and SubTask_Name like @parm4
GO
