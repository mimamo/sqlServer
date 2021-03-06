USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xqmt200_upd_table]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xqmt200_upd_table] 
@Parm1 char(6) 
as 
update XQMT2SCR 
set STDS = (select sum(amount * ca_id07) 
from pjtran t 
inner join pjproj p on t.project = p.project 
inner join pjacct on t.acct = pjacct.acct 
inner join xpa940sort s on ca_id04 = sortid 
where Sortid = 200 
and SortID not in (140, 150) 
and t.project not in (select project from xqpjcscr) 
and substring(t.project,12,2) not in ('ST', 'IA') 
and customer not in ('DNV', 'INT')  
and fiscalno = @Parm1), 
STF = (select sum(amount * ca_id07) 
from pjtran t 
inner join pjproj p on t.project = p.project 
inner join pjacct on t.acct = pjacct.acct 
inner join xpa940sort s on ca_id04 = sortid 
where Sortid = 220 
and SortID not in (140, 150) 
and t.project not in (select project from xqpjcscr) 
and substring(t.project,12,2) not in ('ST', 'IA') 
and customer not in ('DNV', 'INT') 
and fiscalno = @Parm1), 
STO = (select sum(amount * ca_id07) 
from pjtran t 
inner join pjproj p on t.project = p.project 
inner join pjacct on t.acct = pjacct.acct 
inner join xpa940sort s on ca_id04 = sortid 
where Sortid = 310 
and SortID not in (140, 150) 
and t.project not in (select project from xqpjcscr) 
and substring(t.project,12,2) not in ('ST', 'IA') 
and customer not in ('DNV', 'INT') 
and fiscalno = @Parm1), 
STS = (select sum(amount * ca_id07) 
from pjtran t 
inner join pjproj p on t.project = p.project 
inner join pjacct on t.acct = pjacct.acct 
inner join xpa940sort s on ca_id04 = sortid 
where Sortid = 230 
and SortID not in (140, 150) 
and t.project not in (select project from xqpjcscr) 
and substring(t.project,12,2) not in ('ST', 'IA') 
and customer not in ('DNV', 'INT') 
and fiscalno = @Parm1) 
where period = @Parm1
GO
