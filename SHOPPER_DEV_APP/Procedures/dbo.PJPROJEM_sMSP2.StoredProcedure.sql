USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sMSP2]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sMSP2] @Project varchar (16) as
select p.employee 
from 
PJPROJEM p
INNER JOIN
	PJEMPLOY e on p.employee = e.employee 
where 
p.project = @Project and 
e.MSPInterface = 'Y' 

UNION

select s.employee
from
PJPROJEM s
where s.employee = '*' and 
s.project = @Project
GO
