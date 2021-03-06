USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SMSP]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SMSP]  @parm1 smalldatetime  as
SELECT M1.employee, M1.emp_name, M1.MSPRes_UID, M1.edate, r2.labor_rate
from
    (SELECT e.employee, e.emp_name, e.MSPRes_UID, MAX(r.effect_date)as edate
       FROM Pjemploy e
	   JOIN Pjemppjt r
		 ON e.employee = r.employee
        where e.mspinterface = 'Y' and
	  	   	e.mspres_UID <> 0 and
	  		r.project = 'na' and
      		r.effect_date <= @parm1
		group by e.employee, e.emp_name, e.MSPRes_UID) as M1,
	pjemppjt r2
where
M1.employee = r2.employee and
   M1.edate = r2.effect_date
GO
