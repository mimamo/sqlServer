USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk6]    Script Date: 12/16/2015 15:55:26 ******/
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
