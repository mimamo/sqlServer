USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SPK4]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SPK4]  @parm1 varchar (10) , @parm2 varchar (16)   as
select * from PJEMPPJT
where
employee  = @parm1 and
project like @parm2
order by employee, project, effect_date desc
GO
