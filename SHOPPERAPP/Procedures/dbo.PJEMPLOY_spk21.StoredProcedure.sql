USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_spk21]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_spk21] as
select  employee, emp_name   from PJEMPLOY
where   emp_status   =    'A'
order by employee
GO
