USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[XM04091_Main]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[XM04091_Main] AS 

Select
  d.A_ri_id,
  d.ri_id,
  h.VendID,
  h.Status,
  h.PerEnt,
  h.PerClosed,
  h.Lupd_DateTime,
  p.customer,
  p.project_desc,
  c.Name Cust_Name,
  v.Name Vend_Name,
  b.BuyerName,
  d.PONbr,
  d.LineRef,
  d.CuryExtCost,
  d.ReqdDate,
  d.ProjectID,
  d.TaskID,
  d.Vouch_Total
from XM04091_PODetail d
  left outer join rptruntime r
    on d.ri_id = r.ri_id
  join Purchord h
  on d.PONbr = h.PONbr
  left outer join PJPROJ p on d.ProjectID = p.project
  left outer join Customer c on p.customer = c.CustId
  left outer join Vendor v on h.VendID = v.VendId
  left outer join SIBuyer b on h.Buyer = b.Buyer
where ((h.Status in ('P','O') and h.PerEnt <= r.begpernbr)
  or ((h.Status in ('M','X') and h.PerEnt <= r.begpernbr)
  and (h.PerClosed > r.begpernbr or
    Substring(Convert(Varchar,h.Lupd_DateTime,120),1,4) + Substring(Convert(Varchar,h.Lupd_DateTime,120),6,2) > r.begpernbr)))
 --and (d.A_ri_id = '593' or d.A_ri_id = '9999')
 --order by p.customer, d.projectid,d.ponbr
GO
