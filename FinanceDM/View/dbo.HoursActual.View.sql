USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'HoursActual'
                AND type = 'V'
           )
    DROP VIEW [dbo].[HoursActual]
GO

CREATE VIEW [dbo].[HoursActual]

as

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActual 
*
*   Creator:    Michelle Morales 
*   Date:		03/22/2016      
*   
*
*   Notes:      Part of an A/B switch, this is the view that clients are using


				select top 100 * 
				from HoursReporting.dbo.HoursActual_A 

				select top 100 * 
				from HoursReporting.dbo.HoursActual_B 
				
				select *
				from HoursReporting.dbo.HoursActual_Current
				
				select *
				from HoursReporting.dbo.HoursActual_Current
	

*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

select Company,
	CustomerId,
	CustomerName,
	ClassId,
	ClassGroup,
	ProductId,
	ProductDesc,
	ProjectId,
	ProjectDesc,
	JobType,
	JobSubType,
	ClientContact,
	ClientEmail,
	adpId,
	EmployeeDeptId,
	DepartmentName,
	SubDept,
	SubDeptName,	
	EmployeeName,
	EmployeeEmail,
	EmployeeTitle,
	Approver,
	ApproverEmail,
	FunctionCode,
	[Hours],
	PeriodApproved,
	WeekEndingDate,
	DateWorked,
	WMJFlag,
	WMJHours,
	SumOfFteEquity,
	BusinessUnit,
	SubUnit,
	Brand,
	RetainedOOS,
	DocNbr,
	DetailNum,
	BillBatchId,
	BatchId,
	Employee,
	RowId,	
	DateAdded
from FinanceDM.dbo.HoursActual_Current


GO