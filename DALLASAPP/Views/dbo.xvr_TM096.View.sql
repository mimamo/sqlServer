USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_TM096]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_TM096] 
  
AS  
--done  
SELECT RI_ID  
, Period_End_Date  
, emp_id  
, emp_name  
, ADPFileId  
, Sum(Day1Hours) as Day1Hours  
, Sum(Day2Hours) as Day2Hours  
, Sum(Day3Hours) as Day3Hours  
, Sum(Day4Hours) as Day4Hours  
, Sum(Day5Hours) as Day5Hours  
, Sum(Day6Hours) as Day6Hours  
, Sum(Day7Hours) as Day7Hours  
, SUM(UnpaidHours) as UnpaidHours
, Sum(PTOHours) as PTOHours  
, Sum(GenHours) as GenHours  
, Sum(WTDHours) as WTDHours  
, Client_ID
, Product_ID
, Project_ID
, TC_Status
, Empmnt_Status
, Effective_Date
, Project
, TempEmp
, Dept_ID
, Department
, WorkStateID  
, WorkState
, DateTimeCompleted
, DateTimeApproved
, Type
FROM xwrk_TM096  
Group by RI_ID, Project_ID, Period_End_Date, emp_id, emp_name, ADPFileID, TempEmp, Client_ID, Product_ID, Project,
	Dept_ID, Department, WorkState, WorkStateID, DateTimeApproved, DateTimeCompleted, TC_Status, Empmnt_Status, 
	Effective_Date, Type
GO
