USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTPER_sall]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTPER_sall] @parm1 varchar (6)  as
select * from PJUTPER
where   period like @parm1
	order by period
GO
