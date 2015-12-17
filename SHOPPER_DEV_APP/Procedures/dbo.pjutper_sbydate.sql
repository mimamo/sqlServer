USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjutper_sbydate]    Script Date: 12/16/2015 15:55:29 ******/
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
