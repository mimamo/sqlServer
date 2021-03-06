USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_PA965_PO]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[xvr_PA965_PO]

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
