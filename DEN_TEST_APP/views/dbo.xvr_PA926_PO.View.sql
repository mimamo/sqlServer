USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA926_PO]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA926_PO]

as
SELECT p.ProjectID
, sum(CuryExtCost) as 'ExtCost'
, sum(CuryCostVouched) as 'CostVouched'
FROM PurOrdDet p join PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
GROUP BY p.ProjectID
GO
