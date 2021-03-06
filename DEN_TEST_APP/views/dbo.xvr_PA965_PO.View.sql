USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA965_PO]    Script Date: 12/21/2015 14:10:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA965_PO]

as
select 
p.ProjectID,
sum(CuryExtCost) as 'ExtCost',
sum(CuryCostVouched) as 'CostVouched'
from PurOrdDet p join PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
group by p.ProjectID
GO
