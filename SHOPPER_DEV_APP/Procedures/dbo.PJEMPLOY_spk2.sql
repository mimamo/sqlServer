USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_spk2]    Script Date: 12/16/2015 15:55:26 ******/
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
