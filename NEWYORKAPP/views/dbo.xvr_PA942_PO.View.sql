USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_PA942_PO]    Script Date: 12/21/2015 16:00:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA942_PO]


AS
 
SELECT p.ProjectID
, sum(CuryExtCost) as 'ExtCost'
, sum(CuryCostVouched) as 'CostVouched'
FROM PurOrdDet p join PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
GROUP BY p.ProjectID
GO
