USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_scust2]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_scust2] @parm1 varchar (15) , @parm2 varchar (1)  as
select PJPROJ.*,
	MGR1.emp_name,
	MGR2.emp_name,
	customer.name
from PJPROJ
	left outer join PJEMPLOY MGR1
		on PJPROJ.manager1 = MGR1.employee
	left outer join PJEMPLOY MGR2
		on PJPROJ.manager2 = MGR2.employee
	left outer join CUSTOMER
		on PJPROJ.customer = CUSTOMER.CustId
where PJPROJ.customer = @parm1
	and PJPROJ.status_pa like @parm2
order by PJPROJ.project
GO
