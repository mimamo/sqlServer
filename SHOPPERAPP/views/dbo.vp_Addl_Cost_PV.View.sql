USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_Addl_Cost_PV]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vp_Addl_Cost_PV] AS 
select distinct
PONbr = PurchOrd.PONbr,
POType = PurchOrd.POType,
Status = PurchOrd.Status,
PODate = PurchOrd.PODate,
VENDID = PurchOrd.VendID,
AC_Vendid = PurchOrd.VendID,
CpnyID = PurchOrd .CpnyID,
CuryID  = PurchOrd.CuryID
from PurchOrd
Where 
PurchOrd.status in ("O", "P", "M")--- Order (any others?)
AND PurchOrd.POType in ('OR','SO','DP')


---**  This restricts to open PO's issued to the Voucher vendor in the current company, using the same currency (This should be the same as the current PV) **

UNION

Select Distinct
PONbr = POAddlCost.PONbr,
POType = PurchOrd.POType,
Status = PurchOrd.Status,
PODate = PurchOrd.PODate,
VENDID = PurchOrd.VendID,
AC_Vendid = POAddlCost.VendID,
CpnyID = PurchOrd .CpnyID,
CuryID  = PurchOrd.CuryID
from POAddlCost, PurchOrd
Where 
POAddlCost.VendID != PurchOrd.VendID ---for the purchase order 
AND PurchOrd.status in ("O", "P", "M")--- Order (any others?)
AND PurchOrd.POType in ('OR','SO','DP')
AND POAddlCost.RcptStatus IN ('P', 'F') 
AND POAddlCost.VouchStatus IN ('N', 'P')
GO
