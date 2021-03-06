USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_RptBil]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA930_RptBil]
as
Select 

RI_ID		= a.ri_id,
Project		= a.Project,
VendorCost	= sum(a.VendorCost), 
VendorBill	= sum(a.VendorBill),
POCost		= sum(a.POCost),
FeesCost	= sum(a.FeesCost),
FeesBill	= sum(a.FeesBill),
WIPAPSCost	= sum(a.WIPAPSCost),
WIPAPSBill	= sum(a.WIPAPSBill),
Prebill		= sum(a.Prebill),
Payments	= coalesce(min(b.amount),0) + coalesce(min(h.payment), 0),
Discount	= coalesce(min(b.discount),0),
Estimate	= coalesce(min(c.EAC_Amount),0)


From

xvr_PA930_RptBilDet a left join
xvr_PA930_Pmtsum b on 	a.project = b.project and a.ri_id = b.ri_id left join
xvr_PA930_PJPTDRol_Estimate c on a.project = c.project left join
xvr_PA930_BilHistSum h on a.project = h.project and a.ri_id = h.ri_id 

Group by a.ri_id, a.project
GO
