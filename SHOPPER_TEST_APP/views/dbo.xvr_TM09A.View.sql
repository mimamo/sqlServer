USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_TM09A]    Script Date: 12/21/2015 16:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_TM09A] 
  
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
, HourlyRate
, SalaryAmt
, TempEmp  
FROM xwrk_TM09A   
Group by RI_ID, Period_End_Date, emp_id, emp_name, HourlyRate, SalaryAmt, ADPFileID, TempEmp
GO
