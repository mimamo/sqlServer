USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjutper_sbydate]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjutper_sbydate] @parm1 smalldatetime  as
select * from PJUTPER
where   start_date <= @parm1
and end_date >= @parm1
order by period
GO
