USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_sales_tax_billed_by_proj]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_sales_tax_billed_by_proj] 
as 
select rp.ri_id, pjproj.project, 
isnull((select top 1 actacct from xvr_PA920_main_with_ri_id pa where pa.ri_id = rp.ri_id and pa.project = pjproj.project),0) acct, 
isnull((select sum(amount) 
from pjtran t 
inner join xq_prebill_invoices pb 
on t.tr_id02 = pb.invnbr 
where t.project = pjproj.project 
and fiscalno <= begpernbr 
and acct = 'SALES TAX'), 0) PB_Sales_Tax, 
isnull((select sum(amount) 
from pjtran tr 
where tr.project = pjproj.project 
and fiscalno <= begpernbr 
and acct = 'SALES TAX' 
and not exists(select invnbr from xq_prebill_invoices where invnbr = tr.tr_id02)), 0) ACT_Sales_Tax 
from rptruntime rp 
cross join pjproj
GO
