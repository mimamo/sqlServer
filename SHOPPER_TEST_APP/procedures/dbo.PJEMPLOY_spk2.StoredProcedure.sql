USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_spk2]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_spk2] @parm1 varchar (10)  as
select * from PJEMPLOY
where    employee     like @parm1
and    emp_status   =    'A'
order by employee
GO
