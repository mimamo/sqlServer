USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xPJEMPPJT_Wages]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--View returns current title and wages associated with employees.
-- utilized originally on overtime APS Reports.

CREATE VIEW [dbo].[xPJEMPPJT_Wages]
as
SELECT PJEMPPJT.employee, PJEMPPJT.ep_id05, PJEMPPJT.effect_date, PJEMPPJT.labor_class_cd, PJEMPPJT.Labor_rate as 'HourlyRate', PJEMPPJT.ep_id06 as 'SalaryAmt'
FROM   PJEMPPJT Inner Join (
         SELECT PJEMPPJT.employee, Max(PJEMPPJT.effect_date) as MaxDate
         FROM  PJEMPPJT
         GROUP BY PJEMPPJT.employee
         ) as A
         ON PJEMPPJT.employee = A.employee
         And PJEMPPJT.effect_date = A.MaxDate
GO
