USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_ProjectCleanup]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_ProjectCleanup] @parm1 varchar (16)  as

-- This deletes assignments with no actuals for recently un-integrated Employee's
delete from pjpentem
from pjpentem a
where
(a.employee in (select employee from pjemploy where mspinterface = ' ' and emp_status = 'A' )) and
	a.project = @parm1 and
      (a.actual_amt = 0.0 and
       a.actual_units = 0.0 and
       a.Revadj_amt = 0.0 and
       a.revenue_amt = 0.0)

-- This sets the budget = 0 for recently un-integrated Employee's with actuals
update pjpentem set pjpentem.budget_amt = 0, pjpentem.budget_units = 0
from pjpentem a
where
(a.employee in (select employee from pjemploy where mspinterface = ' ' and emp_status = 'A')) and
      a.project = @parm1 and
      (a.actual_amt <> 0.0 or
       a.actual_units <> 0.0 or
       a.Revadj_amt <> 0.0 or
       a.revenue_amt <> 0.0)

-- This deletes assignments with no actuals for recently un-integrated Tasks
delete from pjpentem
from pjpentem a left outer join pjpent t on
(a.project = t.project and a.pjt_entity = t.pjt_entity)
where
      a.project = @parm1 and
      t.mspinterface <> 'Y' and
      (a.actual_amt = 0.0 and
  	 a.actual_units = 0.0 and
  	 a.Revadj_amt = 0.0 and
  	 a.revenue_amt = 0.0)

-- This sets the budget = 0 for recently un-integrated Tasks with actuals
update pjpentem set pjpentem.budget_amt = 0, pjpentem.budget_units = 0
from pjpentem a left outer join pjpent t on
(a.project = t.project and a.pjt_entity = t.pjt_entity)
where
      a.project = @parm1 and
	t.mspinterface <> 'Y' and
 	(a.actual_amt <> 0.0 or
	 a.actual_units <> 0.0 or
  	 a.Revadj_amt <> 0.0 or
	 a.revenue_amt <> 0.0)
GO
