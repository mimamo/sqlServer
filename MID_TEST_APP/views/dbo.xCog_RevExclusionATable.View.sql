USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xCog_RevExclusionATable]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_RevExclusionATable]
AS

-- This view is for importing access tables in the Revenue Model.
-- Base = WRITE, Remove Obsolete, Save as RevenuePlanningExclusion File.
-- Dimension = Input, cube = RevenuePlanning, include e list.


Select *
From (
--      OOS Project Exlucsions      *******************************
-- OOS Products
Select Distinct 'Measure' as Item
	, EListItemParentName
	, 'HIDDEN' AS AccessLevel
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
) a
Where EListItemName is not null

	
UNION ALL

---- OOS jobs in ELIST

Select 'Measure' as Item
	, EListItemName as EList
	, 'HIDDEN' as AccessLevel
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
) b
Where EListItemName is not null
	
	
	

--    SEA Exclusions    ******************************
UNION ALL

Select 'Measure' as Item
	, EListItemname as EListItem
	, 'NODATA' as AccessLevel
From xCog_RevEList
Where EListItemParentName like '%SEA'
	OR EListItemName = 'SEA'


) RevExclusionATable
GO
