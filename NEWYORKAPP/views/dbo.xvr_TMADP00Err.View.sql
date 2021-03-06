USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_TMADP00Err]    Script Date: 12/21/2015 16:00:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[xvr_TMADP00Err]
AS	
--New ADP Dept Codes?
Select '01NewDeptCodes' as Source
, '' as ADPID
, '' as EmpId
, '' emp_name
, '' AS Emp_Status
, '' as Date_Hired
, '' as Date_Terminated
, XTMADP00_EmpList.DepartmentID
, '' as gl_subAcct
, '' as TranslatedSubAcct
, '' as 'PayCd'
, '' as RateType
, '' as ADPState
, '' as DSLState
, '' as DSLHrRate
, '' as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
from XTMADP00_EmpList Left Outer Join xTMADP00_Dept ON XTMADP00_EmpList.DepartmentID = xTMADP00_Dept.DeptCode
Where xTMADP00_Dept.DeptCode is null
Group By XTMADP00_EmpList.DepartmentID, xTMADP00_Dept.DeptCode

UNION ALL

--ADP ID does not exist in DSL and visa versa
Select '02ADPNoDSL' as Source
, a.CoFileNumber as ADPID
, '' as EmpId
,  a.LastName + ', ' + a.FirstName as emp_name
,  '' AS Emp_Status
, a.HireDate as Date_Hired
, '' as Date_Terminated
, a.DepartmentId
, '' as gl_subAcct
, '' as TranslatedSubAcct
, '' as 'PayCd'
, a.RateType
, a.State as ADPState
, '' as DSLState
, '' as DSLHrRate
, a.APSHourlyRate as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
From XTMADP00_EmpList a Left Outer Join PJEMPLOY e ON a.CoFileNumber = e.User2
Where e.User2 is null
	
UNION ALL

Select '03DSLNoADP' as Source
, CASE WHEN e.user2 = '' THEN 'XXXX'
	ELSE e.user2
	END  as 'ADPID', e.employee as EmpID
, Replace(e.emp_name, '~', ', ') as emp_name
, e.Emp_Status
, e.Date_Hired
, e.Date_Terminated
, a.DepartmentID
, e.gl_subacct
, '' as TranslatedSubAcct
, '' as 'PayCd'
, a.RateType
, a.[State] as ADPState
, e.em_id16 as DSLState
, '' as DSLHrRate
, a.APSHourlyRate as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
from PJEMPLOY e Left Outer Join XTMADP00_EmpList a ON e.User2 = a.CoFileNumber
Where a.CoFileNumber is Null
	and e.emp_status = 'A' 
	and e.emp_type_cd <> 'PROD' 

UNION All


--Sub Account Variance
Select '04DeptVar' as Source
, PJEMPLOY.user2 as ADPID
, PJEMPLOY.Employee as EmpID
, Replace(PJEMPLOY.emp_name, '~', ', ') as emp_name
, PJEMPLOY.Emp_Status
, PJEMPLOY.Date_Hired 
, PJEMPLOY.Date_Terminated
, xTMADP00_EmpList.DepartmentID
, PJEMPLOY.gl_subAcct
, XTMADP00_Dept.DSLSubAcct as TranslatedSubAcct
, '' as 'PayCd'
, xTMADP00_EmpList.RateType as RateType
, xTMADP00_EmpList.[State] as ADPState
, PJEMPLOY.em_id16 as DSLState
, '' as DSLHrRate
, xTMADP00_EmpList.APSHourlyRate as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
From XTMADP00_EmpList Inner Join PJEMPLOY ON XTMADP00_EmpList.CoFileNumber = PJEMPLOY.User2
	Inner Join XTMADP00_Dept ON XTMADP00_EmpList.DepartmentID = XTMADP00_Dept.DeptCode
Where XTMADP00_Dept.DSLSubAcct <> PJEMPLOY.gl_subAcct
	And emp_Status = 'A'
--Order by XTMADP00_Dept.DSLSubAcct, PJEMPLOY.gl_subAcct, PJEMPLOY.emp_name

UNION ALL

--Exempt Variance
Select '05ExemptVar' as Source
, PJEMPLOY.user2 as ADPID
, PJEMPLOY.Employee as EmpID
, Replace(PJEMPLOY.emp_name, '~', ', ') as emp_name
, PJEMPLOY.Emp_Status
, PJEMPLOY.Date_Hired
, PJEMPLOY.Date_Terminated
, XTMADP00_EmpList.DepartmentID
, PJEMPLOY.gl_subacct
, '' as TranslatedSubAcct
, xPJEMPPJT.ep_id05 as PayCd
, XTMADP00_EmpList.RateType
, XTMADP00_EmpList.[State] as ADPState
, PJEMPLOY.em_id16 as DSLState
, '' as DSLHrRate
, XTMADP00_EmpList.APSHourlyRate as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
From XTMADP00_EmpList Inner Join PJEMPLOY ON XTMADP00_EmpList.CoFileNumber = PJEMPLOY.User2
	Inner JOIN xPJEMPPJT ON PJEMPLOY.Employee = xPJEMPPJT.Employee
Where ( (xPJEMPPJT.ep_id05 = 'S1' and XTMADP00_EmpList.RateType <> '4')
	OR (xPJEMPPJT.ep_id05 <> 'S1' and XTMADP00_EmpList.RateType = '4'))
	AND PJEMPLOY.emp_Status = 'A'
--Order by PJEMPLOY.Employee	

UNION ALL

--Work State Variance
Select '06StateVar' as Source
, PJEMPLOY.user2 as ADPID
, PJEMPLOY.Employee as EmpID
, Replace(PJEMPLOY.emp_name, '~', ', ') as emp_name
, PJEMPLOY.Emp_Status
, PJEMPLOY.Date_Hired
, PJEMPLOY.Date_Terminated
, XTMADP00_EmpList.DepartmentID
, PJEMPLOY.gl_subacct
, '' as TranslatedSubAcct
, '' as 'PayCd'
, XTMADP00_EmpList.RateType
, XTMADP00_EmpList.[State] as ADPState
, PJEMPLOY.em_id16 as DSLState
, '' as DSLHrRate
, XTMADP00_EmpList.APSHourlyRate as ADPHrRate
, '' as DSLSalaryAmt
, '' as 'LabClsCd'
From XTMADP00_EmpList Inner JOIN PJEMPLOY ON XTMADP00_EmpList.CoFileNumber = PJEMPLOY.User2
	JOIN XTMADP00_State ON XTMADP00_EmpList.State = XTMADP00_State.Descr
Where XTMADP00_State.State <> PJEMPLOY.em_id16 
	AND PJEMPLOY.emp_Status = 'A'

UNION ALL

--APS Wage Check
Select '07APSWageCheck' as Source
, PJEMPLOY.user2 as ADPID
, PJEMPLOY.Employee as EmpID
, Replace(PJEMPLOY.emp_name, '~', ', ') as emp_name
, PJEMPLOY.Emp_Status
, PJEMPLOY.Date_Hired
, PJEMPLOY.Date_Terminated
, XTMADP00_EmpList.DepartmentID
, PJEMPLOY.gl_subacct
, '' as TranslatedSubAcct
, xPJEMPPJT.ep_id05 as 'PayCd'
, XTMADP00_EmpList.RateType
, XTMADP00_EmpList.[State] as ADPState
, PJEMPLOY.em_id16 as DSLState
, xPJEMPPJT.HourlyRate as DSLHrRate
, XTMADP00_EmpList.APSHourlyRate as ADPHrRate
, xpjemppjt.SalaryAmt as 'DSLSalaryAmt'
, '' as 'LabClsCd'
From XTMADP00_EmpList Inner Join PJEMPLOY ON XTMADP00_EmpList.CoFileNumber = PJEMPLOY.User2
	Inner JOIN xPJEMPPJT_Wages xPJEMPPJT ON PJEMPLOY.Employee = xPJEMPPJT.Employee
Where PJEMPLOY.gl_subacct = '1031'
	and xPJEMPPJT.HourlyRate <> XTMADP00_EmpList.APSHourlyRate
	and PJEMPLOY.Employee not in ('CGOLDEN','KRYSZ','LSPORTE')
	and PJEMPLOY.emp_status = 'A'
	and PJEMPLOY.emp_type_cd <> 'PROD'
--Order by PJEMPLOY.Employee

UNION ALL

--Other Wage Check
Select '08OtherWageCheck' as Source
, PJEMPLOY.user2 as ADPID
, PJEMPLOY.Employee as EmpID
, Replace(PJEMPLOY.emp_name, '~', ', ') as emp_name
, PJEMPLOY.Emp_Status
, PJEMPLOY.Date_Hired
, PJEMPLOY.Date_Terminated
, xTMADP00_EmpList.DepartmentID
, PJEMPLOY.gl_subacct
, '' as TranslatedSubAcct
, xPJEMPPJT.ep_id05 as 'PayCd'
, XTMADP00_EmpList.RateType
, xTMADP00_EmpList.[State] as ADPState
, PJEMPLOY.em_id16 as DSLState
, xPJEMPPJT.HourlyRate as DSLHrRate
, xTMADP00_EmpList.APSHourlyRate as ADPHrRate
, xPJEMPPJT.SalaryAmt as 'DSLSalaryAmt'
, '' as 'LabClsCd'
From XTMADP00_EmpList Inner Join PJEMPLOY ON XTMADP00_EmpList.CoFileNumber = PJEMPLOY.User2
	Inner JOIN xPJEMPPJT_Wages xPJEMPPJT ON PJEMPLOY.Employee = xPJEMPPJT.Employee
Where PJEMPLOY.gl_subacct <> '1031'
	and PJEMPLOY.emp_status = 'A'
	and PJEMPLOY.emp_type_cd <> 'PROD'
	and NOT ( (xPJEMPPJT.HourlyRate = '0' AND xPJEMPPJT.SalaryAmt = '1' ) OR (xPJEMPPJT.HourlyRate = '1' AND xPJEMPPJT.SalaryAmt = '0' ) OR  (xPJEMPPJT.HourlyRate = '1' AND xPJEMPPJT.SalaryAmt = '1' ) )
--Order by PJEMPLOY.Employee


UNION ALL


Select *
From (
SELECT  '09EmpSetup' as Source
, CASE WHEN e.user2 = '' THEN 'XXXX'
	ELSE e.user2
	END  as 'ADPID'
, e.employee as 'EmpID'
, Replace(e.emp_name, '~', ', ') as 'emp_name'
, e.Emp_Status
, e.Date_Hired
, e.Date_Terminated
, '' as DepartmentId
, e.gl_subacct
, '' as TranslatedSubAcct
, ISNULL(xe.ep_id05, 'XXXX') as 'PayCd'
, '' as RateType
, '' as ADPState
, em_id16 as DSLState
, xe.HourlyRate as DSLHrRate
, '' as ADPHrRate
, xe.SalaryAmt as DSLSalaryAmt
, ISNULL(xe.labor_class_cd, 'XXXX') as 'LabClsCd'
FROM PJEMPLOY e LEFT JOIN xPJEMPPJT_Wages xe ON e.employee = xe.employee
	LEFT JOIN SubAcct s ON e.gl_subacct = s.Sub
WHERE e.emp_type_cd <> 'PROD'
	and emp_status = 'A'
) a 
Where (a.PayCd = 'XXXX'
	OR a.ADPID = 'XXXX'
	OR a.LabClsCd = 'XXXX' )
	AND ( a.EmpID NOT IN ('ASTUDIO', 'FAVTEST','HRAPPROVER','HRSALLOC','PAYROLLADM', 'STSUSER') )



/*

--Title Variance Check
Select PJEMPLOY.Employee as EmpID, PJEMPLOY.emp_name as EmployeeName, PJEMPLOY.emp_status as EmpSatus, PJEMPLOY.date_terminated, 
		PJEMPLOY.user2 as ADPID, PJCODE.Code_Value as TitleCode, XTMADP00_EmpList.JobTitleDescr AS ADPTitle, 
		 PJCODE.Code_Value_Desc as DSLTitleDesc, xPJEMPPJT.Effect_Date
From XTMADP00_EmpList Inner Join SQL1.DenverApp.dbo.PJEMPLOY ON XTMADP00_EmpList.FileNumber = PJEMPLOY.User2
	Inner Join SQL1.DenverApp.dbo.xPJEMPPJT on PJEMPLOY.employee = xPJEMPPJT.employee
	Inner Join SQL1.DenverApp.dbo.PJCODE ON xPJEMPPJT.Labor_class_cd = PJCODE.Code_value
Where PJEMPLOY.emp_status = 'A'
	and PJCODE.Code_type = 'LABC'
	and PJCODE.Code_Value_Desc <> XTMADP00_EmpList.JobTitleDescr
Order by PJEMPLOY.employee
*/
GO
