USE [financeDm]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   financeDm.dbo.DslHoursActual
*
*   Creator: Michelle Morales
*   Date: 3/31/2016		
*		
*
*   Notes:      
				select *
				from financeDm.dbo.DslHoursActual

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'DslHoursActual') < 1
begin	

create table DslHoursActual
(
	DepartmentID varchar(24),
	DepartmentName varchar(30),
	ProjectID varchar(16),
	ProjectDesc varchar(60),
	ClientID varchar(30),
	ClientName varchar(60),
	ProductID varchar(30),
	ProductDesc varchar(30),
	Employee_Name varchar(60),
	ADPID varchar(30),
	Title varchar(60),
	CurMonth varchar(2),
	CurHours float,
	CurYear int,
	fiscalno varchar(6),
	functionCode varchar(32),
	WeekEndingDate datetime,
	company varchar(20),
	rowId int identity(1,1),
	constraint pkc_DslHoursActual primary key clustered (fiscalno, ClientID, ADPID, ProjectId, rowId) 
)

end
go

SET ANSI_PADDING OFF
GO



---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.DslHoursActual TO BFGROUP
GRANT SELECT, CONTROL ON dbo.DslHoursActual TO MSDSL
GRANT SELECT on dbo.DslHoursActual TO public
GRANT SELECT on dbo.DslHoursActual TO MSDynamicsSL

