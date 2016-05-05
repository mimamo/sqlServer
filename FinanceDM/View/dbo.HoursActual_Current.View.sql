USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'HoursActual_Current'
                AND type = 'V'
           )
    DROP VIEW [dbo].[HoursActual_Current]
GO

CREATE VIEW [dbo].[HoursActual_Current]

as


/*******************************************************************************************************
*   FinanceDM.dbo.HoursActual_Current
*
*   Creator:    Michelle Morales 
*   Date:		03/21/2016   
*   
*
*   Notes:      Part of an A/B switch, this is the view that the FinanceDM.dbo.HoursActual
				view is looking at, at all times

				select top 100 * 
				from FinanceDM.dbo.HoursActual_A 

				select top 100 * 
				from FinanceDM.dbo.HoursActual_B 
				
				select *
				from FinanceDM.dbo.HoursActual
	

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
	SumOfFteEquiv,
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
from FinanceDM.dbo.HoursActual_A

GO
SET ANSI_PADDING OFF
GO
---------------------------------------------
-- permissions
---------------------------------------------

grant select on HoursActual_Current to BFGROUP 
go

grant insert on HoursActual_Current to BFGROUP 
go

grant update on HoursActual_Current to BFGROUP 
go

grant delete on HoursActual_Current to BFGROUP 
go
