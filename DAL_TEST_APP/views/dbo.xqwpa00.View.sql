USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqwpa00]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqwpa00] 
as 
select rp.ri_id, pjproj.customer, customer.name customer_name, pjtran.crtd_prog, pjtran.project, 
pjtran.acct, trans_date, tr_comment, pjtran.fiscalno, amount, 
case when datediff(day, trans_date, reportdate) < 30 then amount else 0 end Currnt, 
case when datediff(day, trans_date, reportdate) between 31 and 60 then amount else 0 end PD31_to_60, 
case when datediff(day, trans_date, reportdate) between 61 and 90 then amount else 0 end PD61_90, 
case when datediff(day, trans_date, reportdate) between 91 and 120 then amount else 0 end PD91_120, 
case when datediff(day, trans_date, reportdate) between 121 and 150 then amount else 0 end PD121_150, 
case when datediff(day, trans_date, reportdate) between 151 and 180 then amount else 0 end PD151_180, 
case when datediff(day, trans_date, reportdate) > 180 then amount else 0 end over_180 
from rptruntime rp 
cross join pjtran 
--inner join pj_account on pjtran.acct = pj_account.acct and gl_acct = '2100'
inner join pjproj on pjtran.project = pjproj.project 
inner join customer on pjproj.customer = customer.custid 
where fiscalno <= begpernbr 
and pjtran.acct like 'wip%'
GO
