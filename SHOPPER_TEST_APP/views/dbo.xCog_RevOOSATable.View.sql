USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[xCog_RevOOSATable]    Script Date: 12/21/2015 16:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_RevOOSATable]
AS

-- This view is for importing access tables in the Revenue Model.
-- Base = NODATA, Remove Obsolete, Save as Revenue_OOS_Jobs File.
-- Dimension = Input, cube = RevenuePlanningJobs, include e list.

Select *
From (

Select Distinct 'Measure' as Item
	, EListItemParentName
	, 'WRITE' AS AccessLevel
From 
(
Select ISNULL(CognosElistVI, ISNULL(CognosEListV, ISNULL(CognosEListIV, CognosEListIII))) as EListItemParentName
	, Case When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',','')) 
	When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') = 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  
	When j.status_pa = 'I' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  END AS EListItemName
From xProdJobDefault x JOIN Customer c ON x.CustID = c.CustId
	JOIN xIGProdCode p ON x.Product = p.code_ID
	JOIN xcog_xvrRevElist_OOSProjectList j ON x.Product = j.pm_id02
	JOIN xIGProdReporting r ON x.Product = r.ProdID
	LEFT JOIN (Select Distinct ProjectID from GLTran Where FiscYr = '2011' and Acct like '4%') GLActivity ON j.project = GLActivity.ProjectID
Where r.OOS = '1'	
) JobLista
Where EListItemName is not null


UNION ALL

-- OOS Projects in ELIST

Select 'Measure' as Item
	, EListItemName as EList
	, 'WRITE' as AccessLevel
From 
(
Select Case When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',','')) 
	When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') = 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  
	When j.status_pa = 'I' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  END AS EListItemName
From xProdJobDefault x JOIN Customer c ON x.CustID = c.CustId
	JOIN xIGProdCode p ON x.Product = p.code_ID
	JOIN xcog_xvrRevElist_OOSProjectList j ON x.Product = j.pm_id02
	JOIN xIGProdReporting r ON x.Product = r.ProdID
	LEFT JOIN (Select Distinct ProjectID from GLTran Where FiscYr = '2011' and Acct like '4%') GLActivity ON j.project = GLActivity.ProjectID
Where r.OOS = '1'	
) JobList
Where EListItemName is not null



UNION All

Select 'Measure' as Item
	, ElistItemName
	, 'WRITE'
From xCog_RevEList
Where EListItemName like 'Unidentified Project%'


) OOSATable
GO
