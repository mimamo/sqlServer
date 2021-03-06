USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_TM097]    Script Date: 12/21/2015 15:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_TM097]

AS

SELECT e.employee as 'EmpID'
, e.emp_name as 'Employee'
, e.emp_status as 'Status'
, ISNULL(xe.ep_id05, '') as 'PayCd'
, e.gl_subacct as 'DeptID'
, s.Descr as 'Department'
, e.user2 as 'ADPFile#'
, em_id16 as 'WorkState'
, ISNULL(xe.labor_class_cd, '') as 'LabClsCd'
, e.date_hired as 'HireDate'
, e.date_terminated as 'TermDate'
, e.emp_type_cd
FROM PJEMPLOY e LEFT JOIN xPJEMPPJT xe ON e.employee = xe.employee
	LEFT JOIN SubAcct s ON e.gl_subacct = s.Sub
WHERE e.emp_type_cd <> 'PROD'
GO
