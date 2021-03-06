USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table FinanceDM.dbo.HoursActual_B
*
*   Creator:	Michelle Morales
*   Date:		03/21/2015
*		
* 
*   Notes:     Part of an A/B switch, any changes here also need to be made on Hoursctual_a!
 
			select top 100 *
			from FinanceDM.dbo.HoursActual_a
			
			select top 100 *
			from FinanceDM.dbo.HoursActual_B
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'HoursActual_B') < 1

CREATE TABLE [dbo].[HoursActual_B]
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
	SumOfFteEquity float,
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
	constraint [pkc_HoursActual_B] primary key clustered (PeriodApproved desc, ClassId, CustomerId, EmployeeName, ProjectID, rowId)
) ON [PRIMARY]



GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
/*
if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[HoursActual_B]') 
					and name = 'idx_HoursActual_B')
begin

CREATE NONCLUSTERED INDEX idx_HoursActual_B ON [dbo].[HoursActual_B] (company, projectId, BillBatchId, productID, EmployeeDeptId )
INCLUDE (employee, approver, DocNbr) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

--drop index idx_HoursActual_B_DepartmentId_CurMonth on  HoursActual_B

end
go   

*/

---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursActual_B TO BFGROUP

GRANT SELECT, CONTROL ON dbo.HoursActual_B TO MSDSL

GRANT SELECT on dbo.HoursActual_B TO public

GRANT SELECT on dbo.HoursActual_B TO MSDynamicsSL


