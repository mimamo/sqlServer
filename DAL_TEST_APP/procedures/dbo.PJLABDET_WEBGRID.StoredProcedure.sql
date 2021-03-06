USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_WEBGRID]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_WEBGRID] @parm1 varchar (10)  as
select 
ISNULL(labc.code_value_desc,'') "labor_class_desc", 
ISNULL(labc.data2,'') "labor_class_GLAcct",
ISNULL(shft.code_value_desc,'') "shift_desc",
ISNULL(c.name,'') "customer_name", 
ISNULL(cpny_chrg.cpnyname,'') "Company_desc", 
ISNULL(subacct_chrg.descr,'') "subacct_desc",  
ISNULL(account.descr,'') "account_desc", 
p.project_desc, p.labor_gl_acct, p.MSPInterface, p.status_18, 
task.pjt_entity_desc, taskex.pe_id23,  
LD.*
from 	pjlabdet ld 
	join pjproj p on ld.project = p.project -- project description
	join pjpent task on ld.project = task.project and ld.pjt_entity = task.pjt_entity -- for task description
	join pjpentex taskex on ld.project = taskex.project and ld.pjt_entity = taskex.pjt_entity  -- task gl acct
	join vs_company cpny_chrg on ld.CpnyId_chrg = cpny_chrg.cpnyid -- charged company description
	left join subacct subacct_chrg on ld.gl_subacct = subacct_chrg.sub -- charged subacct description
	left join account on ld.gl_acct = account.acct -- gl account description
	left join customer c on p.customer = c.custid -- customer name
	left join pjcode labc on ld.labor_class_cd = labc.code_value and labc.code_type = 'LABC' -- Labor class description two part key! 
	left join pjcode shft on ld.shift = shft.code_value and shft.code_type = 'SHFT' -- Labor class description two part key! 
 where ld.docnbr = @parm1
order by ld.linenbr desc
GO
