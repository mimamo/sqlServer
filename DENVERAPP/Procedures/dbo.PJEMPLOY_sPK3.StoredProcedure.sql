USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sPK3]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sPK3] @parm1 varchar (10)  as
select employee, emp_name, emp_status from PJEMPLOY
where EMPLOYEE = @parm1 AND
EMP_Status = 'A'
order by employee
GO
