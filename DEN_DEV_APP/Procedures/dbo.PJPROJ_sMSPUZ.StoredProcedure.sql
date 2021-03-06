USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sMSPUZ]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sMSPUZ] @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (10), @parm4 varchar (16) as
select t.start_date, t.end_date, px.Project_MSPID, p.pm_id37, a.id5_sw, a.ca_id20, t.mspinterface, ex.Employee_MSPID
from 
PJPROJ p
INNER JOIN
	PJPENT t on p.project = t.project 
LEFT OUTER JOIN
	PJPROJXREFMSP px on p.project = px.project,
PJEMPLOY e
LEFT OUTER JOIN
	PJEMPLOYXREFMSP ex on e.employee = ex.employee,
PJACCT a 
where 
p.project = @parm1 and
t.pjt_entity = @parm2 and
e.employee = @parm3 and
a.acct = @parm4
GO
