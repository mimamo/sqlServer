USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BU971_PO]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU971_PO]

AS

SELECT p.ProjectID
, sum(CuryExtCost) as 'ExtCost'
, sum(CuryCostVouched) as 'CostVouched'
FROM PurOrdDet p join PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
GROUP BY p.ProjectID
HAVING (sum(CuryExtCost) - sum(CuryCostVouched)) <> 0
GO
