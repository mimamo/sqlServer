USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWAGEUN_SPK0]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWAGEUN_SPK0]  @parm1 varchar (10) , @parm2 varchar (4) , @parm3 varchar (2) , @parm4beg smalldatetime , @parm4end smalldatetime   as
select * from PJWAGEUN
where    union_cd           = @parm1
and    labor_class_cd like  @parm2
and    work_type        like  @parm3
and    effect_date between  @parm4beg and @parm4end
order by union_cd,
labor_class_cd,
work_type,
effect_date DESC
GO
