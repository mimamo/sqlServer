USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sMSP]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sMSP] @Project varchar (16) as
select e.employee, ex.Employee_MSPID 
from 
PJPROJEM p
INNER JOIN
	PJEMPLOY e on p.employee = e.employee 
LEFT OUTER JOIN
	PJEMPLOYXREFMSP ex on p.employee = ex.employee
where 
p.project = @Project and 
e.MSPInterface = 'Y'
GO
