USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xqmt200_get_ds_by_customer]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xqmt200_get_ds_by_customer] 
@Parm1 char(6) 
as 
select substring(customer,1,3) customer, sum(amount * ca_id07) Amt 
from pjtran t 
inner join pjproj p on t.project = p.project 
inner join pjacct on t.acct = pjacct.acct 
inner join xpa940sort s on ca_id04 = sortid 
where Sortid = 200 
and SortID not in (140, 150) 
and t.project not in (select project from xqpjcscr) 
and (sortid <> 200 or (substring(t.project,12,2) not in ('ST', 'IA') and substring(t.pjt_entity,1,2) not in ('IN', 'ST')))
and customer not in ('DNV', 'INT') 
and fiscalno = @Parm1 
group by substring(customer,1,3) 
having abs(sum(amount * ca_id07)) >= 0.01
GO
