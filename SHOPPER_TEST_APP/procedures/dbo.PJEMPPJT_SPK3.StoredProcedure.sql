USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SPK3]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SPK3]  @parm1 varchar (10) as
select * from PJEMPPJT
where    employee    = @parm1
and    project = 'na'
order by employee,
project,
effect_date
GO
