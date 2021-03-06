USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sMSPSYNC]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sMSPSYNC] 
	@project varchar (16), 
	@task varchar (32)
as
Select 
	t.trans_date, t.employee, x.Assignment_MSPID,
	ROUND(SUM(ROUND(UNITS,2)),2), 
	ROUND(SUM(ROUND(AMOUNT,2)),2),
	count(*) 
from 
PJTRAN t 
	inner join 
pjacct a on t.acct = a.acct
	inner join
PJPENTEMXREFMSP x on t.project = x.project
				and  t.pjt_entity = x.pjt_entity
				and  t.employee = x.employee
				and  rtrim(t.tr_id23) + rtrim(t.tr_id25) = x.SubTask_Name

where
	t.project = @project and
	t.pjt_entity = @task and
	t.employee <> '' and
	a.ca_id20 = 'W'

GROUP BY 
t.employee, t.project, t.pjt_entity, t.tr_id23, t.tr_id25, t.trans_date, x.Assignment_MSPID
order BY 
t.employee, t.project, t.pjt_entity, t.tr_id23, t.tr_id25, t.trans_date
GO
