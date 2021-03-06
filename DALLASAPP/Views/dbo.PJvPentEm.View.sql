USE [DALLASAPP]
GO
/****** Object:  View [dbo].[PJvPentEm]    Script Date: 12/21/2015 13:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PJvPentEm] as
select	ppe.*,
	pp.pjt_entity_desc,
	p.project_desc,
	"billcuryid" = (select BaseCuryID from GLSetup),
	"NetRevenue" = ppe.Revenue_amt + ppe.Revadj_amt,
	e.manager1,
	e.manager2,
	"ComparedStartDate" = case 
				when (CONVERT(varchar(10),ppe.date_start,101)='01/01/1900' and CONVERT(varchar(10),ppe.date_end,101)='01/01/1900') and (CONVERT(varchar(10),pp.start_date,101)='01/01/1900' and CONVERT(varchar(10),pp.end_date,101)='01/01/1900') then p.start_date
				when (CONVERT(varchar(10),ppe.date_start,101)='01/01/1900' and CONVERT(varchar(10),ppe.date_end,101)='01/01/1900') and (CONVERT(varchar(10),pp.start_date,101)<>'01/01/1900' or CONVERT(varchar(10),pp.end_date,101)<>'01/01/1900')then pp.start_date
				else ppe.date_start
			     end,
	"ComparedEndDate" = case 
				when (CONVERT(varchar(10),ppe.date_start,101)='01/01/1900' and CONVERT(varchar(10),ppe.date_end,101)='01/01/1900') and (CONVERT(varchar(10),pp.start_date,101)='01/01/1900' and CONVERT(varchar(10),pp.end_date,101)='01/01/1900') then p.end_date
				when (CONVERT(varchar(10),ppe.date_start,101)='01/01/1900' and CONVERT(varchar(10),ppe.date_end,101)='01/01/1900') then pp.end_date
				else ppe.date_end
			    end,
	/* ActivityFlag used to determine if actuals are charged or not */
	"ActivityFlag" = case
				when ppe.Actual_units > 0.0 or ppe.Actual_amt > 0.0 then 2
				else 1
			 end,
	"NoDecimalPlaces" = (select DecPl from GLSetup gs inner join Currncy c on gs.BaseCuryID = c.CuryId),
	"Actual_units_display" = CAST(Actual_units as decimal(6,2)),
	"Budget_units_display" = CAST(Budget_units as decimal(6,2)),
	/* This column is used in the BP query for comparison */
	"BlankDate" = CONVERT(smalldatetime,'01/01/1900')
from pjpentem ppe
inner join pjemploy e on ppe.employee = e.employee
inner join pjpent pp on ppe.project = pp.project and ppe.pjt_entity = pp.pjt_entity
inner join pjproj p on pp.project = p.project
GO
