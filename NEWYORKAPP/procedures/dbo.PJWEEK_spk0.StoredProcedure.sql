USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_spk0]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_spk0] @parm1 smalldatetime   as
select * from PJWEEK
where   we_date  = @parm1
	order by we_date
GO
