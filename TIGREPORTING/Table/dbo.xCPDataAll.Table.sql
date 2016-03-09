USE [TIGREPORTING]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   TIGREPORTING.dbo.xCPDataAll
*
*   Creator:	
*   Date:		
*		
*
*   Notes:      
				select top 100 *
				from TIGREPORTING.dbo.xCPDataAll
				
				select project, count(1)
				from TIGREPORTING.dbo.xCPDataAll with (nolock)
				group by project
				having count(1) > 1

				select project, *
				from TIGREPORTING.dbo.xCPDataAll with (nolock)
				where project = '06425715AGY     ' 

				select project, *
				from TIGREPORTING.dbo.xCPDataAll with (nolock)
				where fiscalno is null
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'xCPDataAll') < 1
	

CREATE TABLE [dbo].[xCPDataAll](
	[Type] [nvarchar](50) NULL,
	[ReportGroup] [nvarchar](50) NULL,
	[ReportSortNum] [nvarchar](50) NULL,
	[ReportSort] [nvarchar](50) NULL,
	[ClassGroup] [nvarchar](50) NULL,
	[GroupDesc] [nvarchar](50) NULL,
	[ClassId] [nvarchar](50) NULL,
	[ClassDesc] [nvarchar](50) NULL,
	[CustId] [nvarchar](50) NULL,
	[CustName] [nvarchar](50) NULL,
	[fiscalno] [char](6) NOT NULL,
	[acct_type] [char](5) NULL,
	[acct] [nvarchar](50) NULL,
	[Total] [float] NULL,
	[ProfitCenter] [nvarchar](50) NULL,
	[MajorProfitCenter] [nvarchar](50) NULL,
	[Hours] [float] NULL,
	[Project] [nvarchar](50) NULL,
	[Sub] [char](24) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------
if not exists(select 1
			from tigreporting.information_schema.columns
			where table_name = 'xCPDataAll'
				and column_name = 'RowId')
begin
	alter table dbo.xCPDataAll
	add RowId int identity(1,1) not null
end
go

if not exists(select 1
			from tigreporting.information_schema.columns
			where table_name = 'xCPDataAll'
				and column_name = 'fiscalno'
				and is_nullable = 'yes')
begin
	alter table dbo.xCPDataAll
	alter column fiscalno varchar(6) not null
end
go

/*
ALTER TABLE dbo.xCPDataAll
DROP CONSTRAINT pkc_xCPDataAll 
GO
*/
IF NOT EXISTS (SELECT * 
				FROM sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					AND name = N'pkc_xCPDataAll')
					
ALTER TABLE [dbo].[xCPDataAll] ADD  CONSTRAINT [pkc_xCPDataAll] PRIMARY KEY CLUSTERED 
      ([fiscalno], [rowId])
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
go

IF NOT EXISTS (SELECT * 
				FROM sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					AND name = N'idx_xCPData_Total1')
					
CREATE NONCLUSTERED INDEX idx_xCPData_Total1 ON [dbo].[xCPDataAll]
     ([Total])
 INCLUDE ([ReportSort], [ClassGroup], [GroupDesc], [ClassId], [ClassDesc], [CustId], [CustName], [fiscalno], [ProfitCenter], [Hours]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]



if not exists (select *
				from sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					and name = 'idx_xCPData_Total2')
					
CREATE NONCLUSTERED INDEX idx_xCPData_Total2 ON [dbo].[xCPDataAll]
     ([Total])
 INCLUDE ([ReportSort], [ClassGroup], [GroupDesc], [ClassId], [ClassDesc], [CustId], [CustName], [ProfitCenter], [Hours]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

if not exists (select *
				from sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					and name = 'idx_xCPData_Total3')
CREATE NONCLUSTERED INDEX idx_xCPData_Total3 ON [dbo].[xCPDataAll]
     ([ReportSort])
 INCLUDE ([Type], [ReportGroup], [ClassGroup], [GroupDesc], [ClassId], [ClassDesc], [CustId], [CustName], [fiscalno], [acct], [Total], [ProfitCenter], [Project], [Sub]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

if not exists (select *
				from sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					and name = 'idx_xCPData_Total4')
CREATE NONCLUSTERED INDEX idx_xCPData_Total4 ON [dbo].[xCPDataAll]
     ([ReportSort])
 INCLUDE ([fiscalno], [Total]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

if not exists (select *
				from sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					and name = 'idx_xCPData_Total5')
CREATE NONCLUSTERED INDEX idx_xCPData_Total5 ON [dbo].[xCPDataAll]
     ([ReportSort])
 INCLUDE ([ClassGroup], [GroupDesc], [ClassId], [ClassDesc], [CustId], [CustName], [fiscalno], [acct], [Total], [ProfitCenter], [Project], [Sub]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

if not exists (select *
				from sys.indexes 
				WHERE object_id = OBJECT_ID(N'[dbo].[xCPDataAll]')
					and name = 'idx_xCPData_Total6')
CREATE NONCLUSTERED INDEX idx_xCPData_Total6 ON [dbo].[xCPDataAll]
     ([acct_type])
 INCLUDE ([ClassGroup], [GroupDesc], [ClassId], [ClassDesc], [CustId], [CustName], [fiscalno], [acct], [Total], [ProfitCenter], [Project], [Sub]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]


---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.xCPDataAll TO BFGROUP
go

GRANT SELECT, CONTROL ON dbo.xCPDataAll TO MSDSL
go

GRANT SELECT on dbo.xCPDataAll TO public
go

GRANT SELECT on dbo.xCPDataAll TO MSDynamicsSL
go

