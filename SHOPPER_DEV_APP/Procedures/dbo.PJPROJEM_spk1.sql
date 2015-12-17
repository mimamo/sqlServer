USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_spk1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_spk1] @parm1 varchar (16)  as
select pjprojem.*, pjemploy.emp_name, pjemploy.MSPInterface,
	pjemploy.mspres_uid, pjemploy.employee
from pjprojem
	left outer join pjemploy
		on pjprojem.employee = pjemploy.employee
where pjprojem.project = @parm1
order by pjprojem.employee, pjprojem.project
GO
