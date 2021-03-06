USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table FinanceDM.dbo.HoursActual_A
*
*   Creator:	Michelle Morales
*   Date:		03/21/2015
*		
*
*   Notes:     Part of an A/B switch, any changes made here also need to be made in HoursActual_b!
 
			select top 100 *
			from FinanceDM.dbo.HoursActual_A
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'HoursActual_A') < 1

CREATE TABLE [dbo].[HoursActual_A]
(
	Company varchar(20),
	CustomerId varchar(15),
	CustomerName varchar(60),
	ClassId varchar(6),
	ClassGroup varchar(10),
	ProductId varchar(30),
	ProductDesc varchar(30),
	ProjectId varchar(16),
	ProjectDesc varchar(60),
	JobType varchar(16),
	JobSubType varchar(4),
	ClientContact varchar(30),
	ClientEmail varchar(30),
	adpId varchar(30),
	EmployeeDeptId varchar(24),
	DepartmentName varchar(50),
	SubDept varchar(30),
	SubDeptName varchar(20),	
	EmployeeName varchar(100),
	EmployeeEmail varchar(50),
	EmployeeTitle varchar(80),
	Approver varchar(10),
	ApproverEmail varchar(50),
	FunctionCode varchar(32),
	[Hours] float,
	PeriodApproved varchar(8),
	WeekEndingDate datetime,
	DateWorked datetime,
	WMJFlag varchar(3),
	WMJHours float,
	SumOfFteEquiv float,   -- get rid of this, should just be using SumOfFteEquiv float,
	BusinessUnit varchar(50),
	SubUnit varchar(20),
	Brand varchar(25),
	RetainedOOS varchar(20),
	DocNbr varchar(10),	
	DetailNum int,
	BillBatchId varchar(10),
	BatchId varchar(10),
	Employee varchar(10),
	DateAdded datetime,
	rowId int identity(1,1),
	constraint [pkc_HoursActual_A] primary key clustered (PeriodApproved desc, ClassId, CustomerId, EmployeeName, ProjectID, rowId)
) ON [PRIMARY]



GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
if exists (select *
				from financeDm.information_schema.columns
				where table_name = 'HoursActual_A'
					and column_name = 'SumOfFteEquiv')
begin
	alter table dbo.HoursActual_A
	drop column SumOfFteEquiv
end

/*
if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[HoursActual_A]') 
					and name = 'idx_HoursActual_A')
begin

CREATE NONCLUSTERED INDEX idx_HoursActual_A ON [dbo].[HoursActual_A] (company, projectId, BillBatchId, productID, EmployeeDeptId)
INCLUDE (employee, approver, DocNbr) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

--drop index idx_HoursActual_A_DepartmentId_CurMonth on  HoursActual_A

end
go   
*/
---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursActual_A TO BFGROUP

GRANT SELECT, CONTROL ON dbo.HoursActual_A TO MSDSL

GRANT SELECT on dbo.HoursActual_A TO public

GRANT SELECT on dbo.HoursActual_A TO MSDynamicsSL


