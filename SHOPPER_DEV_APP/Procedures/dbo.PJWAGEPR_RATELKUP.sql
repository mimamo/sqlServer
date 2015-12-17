USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWAGEPR_RATELKUP]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWAGEPR_RATELKUP]  @parm1 varchar (4) , @parm2 varchar (4) , @parm3 varchar (2)   as
If @parm3 = ' ' or @parm3 = '  '
    begin
        Select @parm3 = 'na'
    end
select * from PJWAGEPR
where    prev_wage_cd    = @parm1
and    labor_class_cd  = @parm2
and    group_code      = @parm3
order by      prev_wage_cd,
labor_class_cd,
group_code
GO
