USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_spk2]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_spk2] @parm1 varchar (6) , @parm2 varchar (2)   as
select * from PJWEEK
where   period_num = @parm1
and        week_num  like @parm2
	order by period_num, week_num
GO
