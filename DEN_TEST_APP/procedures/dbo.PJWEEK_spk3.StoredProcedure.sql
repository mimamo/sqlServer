USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_spk3]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_spk3] @parm1 smalldatetime   as
select * from PJWEEK
where   we_date  <= @parm1
	order by we_date desc
GO
