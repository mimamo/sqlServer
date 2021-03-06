USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_BU96C_PO]    Script Date: 12/21/2015 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU96C_PO]

AS

SELECT p.ProjectID
, p.TaskID
, sum(p.CuryExtCost) as 'ExtCost'
, sum(p.CuryCostVouched) as 'CostVouched'
FROM PurOrdDet p join PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
GROUP BY p.ProjectID, p.TaskID
GO
