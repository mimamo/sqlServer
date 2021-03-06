USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sMSP]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sMSP] 
	@project varchar (16), 
	@task varchar (32), 
	@TranDate smalldatetime,
	@employee varchar (10),
	@subTask1 varchar (30),
	@subTask2 varchar (20)
as
Select 
	ROUND(SUM(ROUND(UNITS,2)),2), 
	ROUND(SUM(ROUND(AMOUNT,2)),2) 
from 
PJTRAN t inner join pjacct a on t.acct = a.acct

where
	project = @project and
	pjt_entity = @task and
	trans_date = @TranDate and
	employee = @employee and
	tr_id23 = @subTask1 and
	tr_id25 = @subTask2 and
	a.ca_id20 = 'W'

GROUP BY 
project, pjt_entity, trans_date, employee, tr_id23, tr_id25
order BY 
project, pjt_entity, trans_date, employee, tr_id23, tr_id25
GO
