USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_spk31]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_spk31] as
select  employee, emp_name, emp_status   from PJEMPLOY
where   emp_status   =    'A'
order by emp_name
GO
