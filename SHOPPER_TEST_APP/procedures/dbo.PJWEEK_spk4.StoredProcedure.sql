USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWEEK_spk4]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJWEEK_spk4] @parm1 varchar (6)   as
select * from PJWEEK
where   fiscalno  = @parm1
	order by we_date desc
GO
