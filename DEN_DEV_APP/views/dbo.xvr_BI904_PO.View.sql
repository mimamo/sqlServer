USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BI904_PO]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI904_PO]

AS

SELECT a.ProjectID, a.ExtCost - a.CostVouched as 'OpenPO'
FROM ( 
SELECT p.ProjectID
, sum(CuryExtCost) as 'ExtCost'
, sum(CuryCostVouched) as 'CostVouched'
FROM PurOrdDet p JOIN PurchOrd po on p.PONbr = po.PONbr
WHERE po.[status] in ('O', 'P')
GROUP BY p.ProjectID) a
GO
