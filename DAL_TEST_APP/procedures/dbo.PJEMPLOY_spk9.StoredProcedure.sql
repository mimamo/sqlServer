USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_spk9]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_spk9] @parm1 varchar (250) , @parm2 varchar (10)  as
select * from PJEMPLOY
where
emp_status = 'A' and
EMPLOYEE = @parm2
order by employee
GO
