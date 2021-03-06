USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SPK2]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SPK2]  @parm1 varchar (10) , @parm2 varchar (16) , @parm3 smalldatetime   as
If @parm2 = '' or @parm2 = '  '
    begin
        Select @parm2 = 'na'
    end
select * from PJEMPPJT
where    employee  = @parm1
and      project     =   @parm2
and    effect_date <=  @parm3
order by      employee,
project,
effect_date desc
GO
