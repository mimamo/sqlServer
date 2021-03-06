USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqPA930PositiveBillings]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqPA930PositiveBillings] 
as 
select pb.ri_id, pb.project,
(VendorCost - VendorBill) + POCost + (FeesCost - FeesBill) + (case when PreBill > 0 then -1 * PreBill else PreBill end) To_Be_Billed
from xvr_PA930_RptBil pb 
inner join rptruntime rp on pb.ri_id = rp.ri_id 
inner join pjproj p on pb.project = p.project
and status_pa = 'I'
and end_date > (case when isdate(longanswer00) = 1 then longanswer00 else '01/01/1900' end)
--and end_date > '12/31/2007'
where abs((VendorCost - VendorBill) + POCost + (FeesCost - FeesBill) + (case when PreBill > 0 then -1 * PreBill else PreBill end)) >= 0.01
and pb.project like '%AG'
and pb.project not like 'INT%'
and substring(pb.project, 4, 3) not in ('SEA', 'GEN', 'INT', 'NBZ')
GO
