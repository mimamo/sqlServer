USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_vw_rateinfo]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- Queue Associates                                                                                        --
-- SS 6/6/08                                                                                               --
-- Integer Dallas Employee Salary Report xqemp00.rpt view                                                  --
-- This View was designed to show all/or active employee information in pjemppjt table                     --
-- for maximum affective date records only                                                                 --
-- Current view serves as join view for source report view xq_vw_empinfo                                   --
------------------------------------------------------------------------------------------------------------------------


create view [dbo].[xq_vw_rateinfo]

as

select
	a.employee,
	a.labor_class_cd labor_class,
	a.labor_rate hourly_rate,
	a.ep_id06 weekly_salary
from
	pjemppjt a
where
	a.effect_date=
(
 select
	max(effect_date)
from
	pjemppjt
where
	employee = a.employee
)
GO
