USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmesx00]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmesx00] 
as
select 
 h.employee employee_id,
 e.emp_name employee_name,
 h.approver approver_id,
 a.emp_name approver_name,
 h.docnbr,
 h.le_type timecard_type,
 h.le_status timecard_status,
 h.pe_date week_ending_date,
 d.crtd_datetime approved_date
 from pjlabhdr h left outer join
 pjemploy e on h.employee = e.employee
 left outer join pjemploy a on h.approver = a.employee
 left outer join pjlabdis d on h.docnbr = d.docnbr
 where h.le_status in ('P','X')
GO
