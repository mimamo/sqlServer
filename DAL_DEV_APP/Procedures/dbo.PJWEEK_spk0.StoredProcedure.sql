USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_spk0]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_spk0] @parm1 smalldatetime   as
select * from PJWEEK
where   we_date  = @parm1
	order by we_date
GO
