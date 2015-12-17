USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SPK0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SPK0]  @parm1 varchar (10) , @parm2 varchar (16) , @parm3beg smalldatetime , @parm3end smalldatetime   as
select * from PJEMPPJT
where    employee    = @parm1
and    project     LIKE @parm2
and    effect_date between  @parm3beg and @parm3end
order by employee,
project,
effect_date desc
GO
