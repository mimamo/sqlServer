USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_sI11]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_sI11] @parm1 varchar (6)   as
select  period_num, count(period_num), min(we_date), max(we_date)  from PJWEEK
where   period_num = @parm1
group by period_num
GO
