USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sMSPUZne]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sMSPUZne] @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (16) as
BEGIN
	SELECT 'Project_MSPID' = ISNULL(px.Project_MSPID,''),		
		   'Pjt_Entity_MSPID' = ISNULL(tx.Pjt_Entity_MSPID,''),
			p.pm_id37, a.id5_sw, a.ca_id20, p.mspinterface 
from 
PJPROJ p 
INNER JOIN
	PJPENT t on p.project = t.project 
LEFT OUTER JOIN
	PJPROJXREFMSP px on p.project = px.project
LEFT OUTER JOIN
	PJPENTXREFMSP tx on t.project = tx.project and t.pjt_entity = tx.pjt_entity,
PJACCT a 
where 
p.project = @parm1 and
t.pjt_entity = @parm2 and
a.acct = @parm3
END
GO
