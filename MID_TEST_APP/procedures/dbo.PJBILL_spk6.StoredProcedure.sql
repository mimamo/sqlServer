USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk6]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk6] @parm1 varchar (10)  as
select distinct  e.employee, e.emp_name
from
PJEMPLOY e ,  PJBILL b
where
e.employee = b.biller  and
b.biller Like @parm1
order by e.emp_name
GO
