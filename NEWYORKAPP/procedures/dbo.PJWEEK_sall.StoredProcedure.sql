USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_sall]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_sall] @parm1beg smalldatetime , @parm1end smalldatetime   as
select * from PJWEEK
where   we_date BETWEEN @parm1beg and @parm1end
	order by we_date
GO
