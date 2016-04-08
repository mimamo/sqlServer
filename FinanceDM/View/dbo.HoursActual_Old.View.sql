USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'HoursActual_Old'
                AND type = 'V'
           )
    DROP VIEW [dbo].[HoursActual_Old]
GO

CREATE VIEW [dbo].[HoursActual_Old]

as


/*******************************************************************************************************
*   FinanceDM.dbo.HoursActual_Old
*
*   Creator:    Michelle Morales 
*   Date:		03/21/2016
*   
*
*   Notes:      Part of an A/B switch, this is the view that can be upserted into because it is not
				being used by clients

				select top 100 * 
				from FinanceDM.dbo.HoursActual_A 

				select top 100 * 
				from FinanceDM.dbo.HoursActual_B 
				
				select *
				from FinanceDM.dbo.HoursActual
				
				select *
				from FinanceDM.dbo.HoursActual_Current
				
				select *
				from FinanceDM.dbo.HoursActual_Old
	

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
from FinanceDM.dbo.HoursActual_B

GO
SET ANSI_PADDING OFF
GO
---------------------------------------------
-- permissions
---------------------------------------------

grant select on HoursActual_Old to BFGROUP 
go

grant insert on HoursActual_Old to BFGROUP 
go

grant update on HoursActual_Old to BFGROUP 
go

grant delete on HoursActual_Old to BFGROUP 
go
