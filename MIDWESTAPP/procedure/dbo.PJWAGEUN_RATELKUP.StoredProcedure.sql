USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJWAGEUN_RATELKUP]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWAGEUN_RATELKUP]  @parm1 varchar (10) , @parm2 varchar (4) , @parm3 varchar (2) , @parm4 smalldatetime   as
If @parm3 = '' or @parm3 = '  '
    begin
        Select @parm3 = 'na'
    end
select * from PJWAGEUN
where    union_cd        = @parm1
and    labor_class_cd  = @parm2
and    work_type       = @parm3
and    effect_date    <= @parm4
order by      union_cd,
labor_class_cd,
work_type,
effect_date desc
GO
