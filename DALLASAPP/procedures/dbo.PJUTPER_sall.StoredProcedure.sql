USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTPER_sall]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTPER_sall] @parm1 varchar (6)  as
select * from PJUTPER
where   period like @parm1
	order by period
GO
