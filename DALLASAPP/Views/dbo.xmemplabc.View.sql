USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmemplabc]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/26/10                                                                                             --
-- Created for the Labor Class/Employee Billing Rate Report                                                --
-- This View was created to retrieve the current labor class for an employee                               --
-- Current view serves as join view for source report view XMEBR00                                         --
------------------------------------------------------------------------------------------------------------------------


CREATE view [dbo].[xmemplabc]

as
select
	a.employee,
	a.labor_class_cd labor_class
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
