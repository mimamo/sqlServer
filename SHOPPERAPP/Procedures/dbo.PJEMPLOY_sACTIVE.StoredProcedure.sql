USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_sACTIVE]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_sACTIVE] @parm1 varchar (10)  as
select * from PJEMPLOY
where
emp_status   = 'A' and
EMPLOYEE like @parm1
order by employee
GO
