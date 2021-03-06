USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xCog_ExpEList]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_ExpEList]
AS

-- Used In Cognos Expense
-- Save as ExpenseAccountsATable
-- Base NO DATA, Delete undefined.

Select ExpEList.EListItemName
	, ExpEList.EListItemParentName
	, ExpEList.EListItemCaption
	, Row_Number() Over(Order By EListItemOrder) AS EListItemOrder
	, ExpEList.EListItemViewDepth
	, ExpEList.EListItemReviewDepth
	, ExpEList.EListItemIsPublished 
FROM
(
Select  'Integer' AS EListItemName
	, 'Integer' AS EListItemParentName
	, 'Integer' AS EListItemCaption
	, 1 AS EListItemOrder
	, '-1' AS EListItemViewDepth
	, '-1' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 

UNION ALL

SELECT 'Agency' AS EListItemName
	, 'Integer' AS EListItemParentName
	, 'Agency' AS EListItemCaption
	, 2 AS EListItemOrder
	, '1' AS EListItemViewDepth
	, '1' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 

UNION ALL


Select RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 'Agency' AS EListItemParentName
	, RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 3 AS EListItemOrder
	, '0' AS EListItemViewDepth
	, '0' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 
from SubAcct
Where Active <> '0'
	and Sub Not In ('1031', '1032', '1050', '1051', '1052', '2700', '0000')


UNION ALL
SELECT 'APS' AS EListItemName
	, 'Integer' AS EListItemParentName
	, 'APS' AS EListItemCaption
	, 4 AS EListItemOrder
	, '1' AS EListItemViewDepth
	, '1' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 


UNION ALL
Select RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 'APS' AS EListItemParentName
	, RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 5 AS EListItemOrder
	, '0' AS EListItemViewDepth
	, '0' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 
from SubAcct
Where Active <> '0'
	and Sub In ('1031')


UNION ALL
SELECT 'ICP' AS EListItemName
	, 'Integer' AS EListItemParentName
	, 'ICP' AS EListItemCaption
	, 6 AS EListItemOrder
	, '1' AS EListItemViewDepth
	, '1' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished
	 
UNION ALL
Select RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 'ICP' AS EListItemParentName
	, RTRIM(Sub) + ' - ' + RTRIM(Descr) AS EListItemName
	, 7 AS EListItemOrder
	, '0' AS EListItemViewDepth
	, '0' AS EListItemReviewDepth
	, 'YES' AS EListItemIsPublished 
from SubAcct
Where Active <> '0'
	and Sub In ('1032')

) ExpEList
GO
