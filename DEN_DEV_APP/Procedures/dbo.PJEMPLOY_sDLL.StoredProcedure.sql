USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sDLL]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sDLL] @parm1 varchar (10)  as
select emp_name from PJEMPLOY
where EMPLOYEE = @parm1
order by employee
GO
