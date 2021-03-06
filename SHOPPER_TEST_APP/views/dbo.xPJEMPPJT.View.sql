USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[xPJEMPPJT]    Script Date: 12/21/2015 16:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xPJEMPPJT]
as
SELECT PJEMPPJT.employee, PJEMPPJT.ep_id05, PJEMPPJT.effect_date, PJEMPPJT.labor_class_cd
FROM   PJEMPPJT Inner Join (
         SELECT PJEMPPJT.employee, Max(PJEMPPJT.effect_date) as MaxDate
         FROM  PJEMPPJT
         GROUP BY PJEMPPJT.employee
         ) as A
         ON PJEMPPJT.employee = A.employee
         And PJEMPPJT.effect_date = A.MaxDate
GO
