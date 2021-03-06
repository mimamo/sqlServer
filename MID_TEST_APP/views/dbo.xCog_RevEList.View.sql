USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xCog_RevEList]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xCog_RevEList]
AS


-- Revenue E-List
--Add quotes to eListItemOrder for import

-- Generates correct EListItemOrder
Select RevenueEList.EListItemName
	, RevenueEList.EListItemParentName
	, RevenueEList.EListItemCaption
	, Row_Number() Over(Order By EListItemOrder) AS EListItemOrder
	, RevenueEList.EListItemViewDepth
	, RevenueEList.EListItemReviewDepth
	, RevenueEList.EListItemIsPublished 
from 
(
-- Top of the Node - Integer
Select  'Integer' AS EListItemName
	, 'Integer' AS EListItemParentName
	, 'Integer' AS EListItemCaption
	, 1 AS EListItemOrder
	, '-1' AS EListItemViewDepth
	, '-1' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 
	
UNION ALL

-- Level 1 - CognosEListI
Select CognosElistI as EListItemDescr
	, 'Integer' AS EListItemParentName
	,  CognosElistI As EListItemName
	, 2 AS EListItemOrder
	, 4 AS EListItemViewDepth
	, 4 AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished
From xIGProdReporting
Where CognosElistI is not null
Group by CognosElistI


UNION ALL
-- Level 1 - BillingsEList
Select 'Billings' as EListItemDescr
	, 'Integer' AS EListItemParentName
	,  'Billings' As EListItemName
	, 2 AS EListItemOrder
	, 0 AS EListItemViewDepth
	, 0 AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished


UNION ALL

-- Level 1 - CognosEListII
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 3 as EListItemOrder
	, Max(EListItemViewDepth) as EListItemViewDepth
	, Max(EListItemViewDepth) as EListItemReviewDepth
	, 'YES' as EListItemIsPublished
From 
(
Select CognosElistII as Item
	, CognosElistI AS ItemParent
	, Case When OOS = 'True' THEN
		Case When CognosEListVI is not null THEN
		'5'
		WHEN CognosEListV IS not null then
		'4'
		WHEN CognosEListIV IS not null then
		'3' 
		WHEN CognosEListIII IS not null then
		'2' 
		ELSE '1' END
		ELSE
		Case When CognosEListVI is not null THEN
		'4'
		WHEN CognosEListV IS not null then
		'3'
		WHEN CognosEListIV IS not null then
		'2' 
		WHEN CognosEListIII IS not null then
		'1' 
		Else '0'
		END  END AS EListItemViewDepth
From xIGProdReporting
Where CognosElistII is not null	
) EListII
Group by Item, ItemParent


UNION ALL
--General New Business under levelI
Select 'GEN New Business' as EListItemDescr
	, CognosElistI AS EListItemParentName
	,  'GEN New Business' As EListItemName
	, 4 AS EListItemOrder
	, 0 AS EListItemViewDepth
	, 0 AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished
From xIGProdReporting
Where CognosElistI is not null
Group by CognosElistI



UNION ALL
-- P&G and Miller Coors General New Business under Level II
Select 'GEN New Business - ' + CognosElistII as EListItemDescr
	, CognosElistII AS EListItemParentName
	,  'GEN New Business - ' + CognosElistII As EListItemName
	, 4 AS EListItemOrder
	, 0 AS EListItemViewDepth
	, 0 AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished
From xIGProdReporting
Where CognosElistII  in ('PG', 'MillerCoors')
Group by CognosElistII


UNION ALL

-- Level 1 - CognosEListIII
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 5 as EListItemOrder
	, Max(EListItemViewDepth) as EListItemViewDepth
	, Max(EListItemViewDepth) as EListItemReviewDepth
	, 'YES' as EListItemIsPublished
From (
Select CognosElistIII as Item
	, CognosElistII AS ItemParent
	, Case When OOS = 'True' THEN
		Case When CognosEListVI is not null THEN
		'4'
		WHEN CognosEListV IS not null then
		'3'
		WHEN CognosEListIV IS not null then
		'2' 
		ELSE '1' END
		ELSE
		Case When CognosEListVI is not null THEN
		'3'
		WHEN CognosEListV IS not null then
		'2'
		WHEN CognosEListIV IS not null then
		'1' 
		Else '0'
		END  END AS EListItemViewDepth
From xIGProdReporting
Where CognosElistIII is not null
) ELISTIII
Group by Item, ItemParent


UNION ALL

-- Level 1 - CognosEListIV
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 6 as EListItemOrder
	, Max(EListItemViewDepth) as EListItemViewDepth
	, Max(EListItemViewDepth) as EListItemReviewDepth
	, 'YES' as EListItemIsPublished
From 
(
Select CognosElistIV as Item
	, CognosElistIII AS ItemParent
	,  Case When OOS = 'True' THEN
		Case When CognosEListVI is not null THEN
		'3'
		WHEN CognosEListV IS not null then
		'2'
		ELSE '1' END
		ELSE
		Case When CognosEListVI is not null THEN
		'2'
		WHEN CognosEListV IS not null then
		'1'
		Else '0'
		END  END AS EListItemViewDepth
From xIGProdReporting
Where CognosElistIV is not null
) EListIV
Group by Item, ItemParent


UNION ALL

-- Level 1 - CognosEListV
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 7 as EListItemOrder
	, Max(EListItemViewDepth) as EListItemViewDepth
	, Max(EListItemViewDepth) as EListItemReviewDepth
	, 'YES' as EListItemIsPublished
From 
(
Select CognosElistV as Item
	, CognosElistIV AS ItemParent
	,  Case When OOS = 'True' THEN
		Case When CognosEListVI is not null THEN
		'2'
		ELSE '1' END
		ELSE
		Case When CognosEListVI is not null THEN
		'1'
		Else '0'
		END  END AS EListItemViewDepth
From xIGProdReporting
Where CognosElistV is not null
) EListIV
Group by Item, ItemParent

UNION ALL

-- Level 1 - CognosEListVI
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 8 as EListItemOrder
	, Max(EListItemViewDepth) as EListItemViewDepth
	, Max(EListItemViewDepth) as EListItemReviewDepth
	, 'YES' as EListItemIsPublished
From 
(
Select CognosElistVI as Item
	, CognosElistV AS ItemParent
	,  Case When OOS = 'True' THEN
		'1'
		ELSE '0' END AS EListItemViewDepth
From xIGProdReporting
Where CognosElistVI is not null
) EListIV
Group by Item, ItemParent


Union ALL

--OOS Products Add Unidentified Job
-- Level 1 - CognosEListVI
Select Item as EListItemDescr
	, ItemParent as EListItemParentName
	, Item as IListItemName
	, 9 as EListItemOrder
	, '0' as EListItemViewDepth
	, '0' as EListItemReviewDepth
	, 'YES' as EListItemIsPublished 
From 
(
Select 'Unidentified Project - ' + ISNULL(CognosElistVI, ISNULL(CognosEListV, ISNULL(CognosEListIV, CognosEListIII))) as Item
	, ISNULL(CognosElistV, ISNULL(CognosEListIV, CognosEListIII)) AS ItemParent
From xIGProdReporting
Where OOS = 'TRUE'
) OOSProducts
Where item is not null
Group by Item, ItemParent

UNION ALL

-- OOS Projects in ELIST
Select *
From 
(
Select Case When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',','')) 
	When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') = 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))
		When j.status_pa = 'I' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  END AS EListItemDesc
	, ISNULL(CognosElistVI, ISNULL(CognosEListV, ISNULL(CognosEListIV, CognosEListIII))) as EListItemParentName
	, Case When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',','')) 
	When j.status_pa = 'A' AND ISNULL(GLActivity.ProjectID, 'xx') = 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  
	When j.status_pa = 'I' AND ISNULL(GLActivity.ProjectID, 'xx') <> 'xx' THEN
	RTRIM(j.project) + ' - ' + RTRIM(Replace(j.project_desc, ',',''))  END AS EListItemName
	, 10 AS EListItemOrder
	, 0 AS EListItemViewDepth
	, 0 AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished
From xProdJobDefault x JOIN Customer c ON x.CustID = c.CustId
	JOIN xIGProdCode p ON x.Product = p.code_ID
	JOIN xcog_xvrRevElist_OOSProjectList j ON x.Product = j.pm_id02
	JOIN xIGProdReporting r ON x.Product = r.ProdID
	LEFT JOIN (Select Distinct ProjectID from GLTran Where FiscYr = '2011' and Acct like '4%') GLActivity ON j.project = GLActivity.ProjectID
Where r.OOS = '1'	
) JobList
Where EListItemName is not null
	


UNION ALL

--SEA Is Below
Select Case When EListItemViewDepth = '0' THEN
		EListItemName
		ELSE 
		Case When EListItemName = 'Integer' THEN
		'SEA'
		ELSE ElistItemName + ' SEA' END
		END as EListItemDesc
	,	Case When EListItemName = 'Integer' THEN
		'Integer'
		ELSE
		Case When EListItemParentName = 'Integer' THEN
		'SEA'
		ELSE
		EListItemParentName + ' SEA' END END as EListITemParentName
	, Case When EListItemViewDepth = '0' THEN
		EListItemName
		ELSE 
		Case When EListItemName = 'Integer' THEN
		'SEA'
		ELSE ElistItemName + ' SEA' END
		END as EListItemName
	, 11 as EListITemOrder
	, EListItemViewDepth
	, EListItemViewDepth as EListItemReViewDepth
	, 'YES' as Publish
from xcog_SEAEList


UNION ALL	
--EITF EList Late Entry - 08162011
Select CognosEListII + ' - EITF'
	, CognosEListII as EListItemParentName
	, CognosEListII + ' - EITF'
	, 12 as EListItemOrder
	, '0' as EListItemViewDepth
	, '0' as EListItemReviewDepth
	, 'YES' as EListItemIsPublished 
From xigProdReporting
Where CognosElistI is not null
Group by CognosElistII

	
	 
	
	
) RevenueEList
GO
