USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_sResynch]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_sResynch] @parm1 varchar (16) as
select project, employee from PJPENTEM
where project like @parm1 and
	  Date_start <> ''
group by project, employee
GO
