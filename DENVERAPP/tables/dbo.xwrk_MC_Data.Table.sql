USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   DENVERAPP.dbo.xwrk_MC_Data
*
*   Creator:	
*   Date:		
*		
*
*   Notes:      
			select curMonth, [year], projectId, Employee_Name, count(1)
			from DENVERAPP.dbo.xwrk_MC_Data
			group by curMonth, [year], projectId, Employee_Name
			
			select curMonth, [year], projectId, Employee_Name, *
			from DENVERAPP.dbo.xwrk_MC_Data
			where curMonth = 6
				and [year] = 2012
				and projectId = '04441412AGY'
				and Employee_Name = 'Lassen, Ryan'
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/25/2016 Adding primary key and non-clustered index.
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'xwrk_MC_Data') < 1
	
CREATE TABLE [dbo].[xwrk_MC_Data](
	[Brand] [varchar](25) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](20) NULL,
	[Employee_Name] [varchar](100) NULL,
	[DepartmentID] [varchar](18) NULL,
	[Department] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[POS] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[xconDate] [datetime] NULL,
	[CurMonth] [int] NULL,
	[Year] [int] NULL,
	[Hours] [float] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProjectDesc] [char](60) NULL,
	[ClientID] [char](30) NOT NULL,
	[ProdID] [char](30) NOT NULL,
	[fiscalno] [char](6) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
if exists (select *
			from information_schema.columns
			where table_name = 'xwrk_MC_Data'
				and column_name = 'curMonth'
				and is_nullable = 'YES')

begin
	alter table dbo.xwrk_MC_Data
	alter column curMonth int not null
end
go

if exists (select *
			from information_schema.columns
			where table_name = 'xwrk_MC_Data'
				and column_name = 'Year'
				and is_nullable = 'YES')

begin
	alter table dbo.xwrk_MC_Data
	alter column [Year] int not null
end
go

if exists (select *
			from information_schema.columns
			where table_name = 'xwrk_MC_Data'
				and column_name = 'ProjectID'
				and is_nullable = 'YES')

begin
	alter table dbo.xwrk_MC_Data
	alter column ProjectID varchar(16) not null
end
go

if exists (select *
			from information_schema.columns
			where table_name = 'xwrk_MC_Data'
				and column_name = 'Employee_Name'
				and is_nullable = 'YES')

begin
	alter table dbo.xwrk_MC_Data
	alter column Employee_Name varchar(100) not null
end
go

if not exists (select *
			from information_schema.columns
			where table_name = 'xwrk_MC_Data'
				and column_name = 'row_id')

begin
	alter table dbo.xwrk_MC_Data
	add row_id int identity(1,1) not null
end
go



if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Data]') 
					and name = 'pkc_xwrk_MC_Data')
begin
	alter table dbo.xwrk_MC_Data
	ADD CONSTRAINT [pkc_xwrk_MC_Data] PRIMARY KEY CLUSTERED ([Year], curMonth, ProjectID, row_id)
end
go



if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Data]') 
					and name = 'nci_xwrk_MC_Data')
begin

CREATE NONCLUSTERED INDEX nci_xwrk_MC_Data ON [dbo].[xwrk_MC_Data]
     ([BusinessUnit], [SalesMarketing], [Department], [CurMonth]) include ([Year], [hours], [employee_name])
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

end
go

if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Data]') 
					and name = 'nci_xwrk_MC_Data_Brand_clientID_prodID')
begin

CREATE NONCLUSTERED INDEX nci_xwrk_MC_Data_Brand_clientID_prodID ON [dbo].[xwrk_MC_Data]
     ([Brand], [clientID], [prodID])
 INCLUDE ([DepartmentID], [BusinessUnit], [SalesMarketing]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

end
go

