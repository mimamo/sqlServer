USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xPJTIMDETHDR]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xPJTIMDETHDR]

AS 

SELECT SUM(reg_hours) as 'Hours'
, employee
, docnbr
, CASE WHEN DATEPART(dw, tl_date) = 7 
	THEN tl_date + 1
	WHEN DATEPART(dw, tl_date) = 6
	THEN tl_date + 2
	WHEN DATEPART(dw, tl_date) = 5 
	THEN tl_date + 3
	WHEN DATEPART(dw, tl_date) = 4 
	THEN tl_date + 4
	WHEN DATEPART(dw, tl_date) = 3 
	THEN tl_date + 5
	WHEN DATEPART(dw, tl_date) = 2 
	THEN tl_date + 6
	WHEN DATEPART(dw, tl_date) = 1 
	THEN tl_date END as 'Week_Ending_Date'
, project
, gl_subacct
, tl_date
, linenbr
FROM PJTIMDET
GROUP BY tl_date, employee, docnbr, project, gl_subacct, linenbr
GO
