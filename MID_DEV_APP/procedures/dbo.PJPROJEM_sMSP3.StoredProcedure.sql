USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sMSP3]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sMSP3] @Employee varchar (10) as
select pm.project, p.cpnyid, px.Project_MSPID 
from 
PJPROJEM pm
INNER JOIN
	PJPROJ p on pm.project = p.project 
INNER JOIN
	PJPROJXREFMSP px on pm.project = px.project
where 
pm.employee = @Employee and 
p.MSPInterface = 'Y'
GO
