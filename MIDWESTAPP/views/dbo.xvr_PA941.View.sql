USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_PA941]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA941]

AS

SELECT IsNull(xp.CustID, 'Not Assigned') as 'CustId'
, IsNull(c.Name, 'Not Assigned') as 'CustName'
, IsNull(c.Status, 'M') as 'CustStatus' --M = Missing
, x.code_Group as 'ProdGrp'
, p.code_value_desc as 'ProdGrpDesc'
, x.code_ID as 'ProdId'
, x.descr as 'ProdDesc'
, x.status as 'ProdStatus'
, x.crtd_datetime as 'ProdCrtdDate'
, IsNull(PJStatus.ActiveProjects, 0) as 'ActiveProjects'
, IsNull(Max(PJPROJ.Start_date), '1/1/1900') as 'MaxStart'
, IsNull(Max(PJPROJ.end_date), '1/1/1900') as 'MaxEnd'
, IsNull(Max(PJPROJ.pm_Id08), '1/1/1900') as 'MaxClosed'
, IsNull(Max(PJPROJ.crtd_Datetime), '1/1/1900') as 'LastJobCreated'
, IsNull(Max(PJTRAN.crtd_Datetime), '1/1/1900') as 'LastTrans'
FROM xIGProdCode x LEFT JOIN PJCODE p ON x.code_group = p.Code_value 
		AND p.code_type = '9PCG'
	LEFT JOIN xProdJobDefault xp ON x.code_id = xp.Product
	LEFT JOIN Customer c ON xp.CustID = c.CustId
	LEFT JOIN PJPROJ ON x.code_id = PJPROJ.pm_id02
	LEFT JOIN PJTRAN ON PJPROJ.Project = PJTRAN.project
	LEFT JOIN (SELECT pm_id02, Count(project) as 'ActiveProjects' FROM PJPROJ WHERE status_pa = 'A' GROUP BY pm_id02) PJStatus ON x.code_id = PJStatus.pm_id02
GROUP BY xp.CustID, c.Name, c.Status, x.code_Group, p.code_value_desc, x.code_ID, x.descr, x.status, x.crtd_datetime, PJStatus.ActiveProjects
GO
