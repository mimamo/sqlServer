USE [StageDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.PJTRAN
*
*   Creator:	Michelle Morales
*   Date:		03/21/2016
*		
*
*   Notes:      


*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'PJTran') < 1
	
	
CREATE TABLE [dbo].[PJTran](
	[acct] [char](16) NOT NULL,
	[alloc_flag] [char](1) NOT NULL,
	[amount] [float] NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[batch_id] [char](10) NOT NULL,
	[batch_type] [char](4) NOT NULL,
	[bill_batch_id] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranamt] [float] NOT NULL,
	[data1] [char](16) NOT NULL,
	[detail_num] [int] NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[post_date] [smalldatetime] NOT NULL,
	[project] [char](16) NOT NULL,
	[Subcontract] [char](16) NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[trans_date] [smalldatetime] NOT NULL,
	[tr_comment] [char](100) NOT NULL,
	[tr_id01] [char](30) NOT NULL,
	[tr_id02] [char](30) NOT NULL,
	[tr_id03] [char](16) NOT NULL,
	[tr_id04] [char](16) NOT NULL,
	[tr_id05] [char](4) NOT NULL,
	[tr_id06] [float] NOT NULL,
	[tr_id07] [float] NOT NULL,
	[tr_id08] [smalldatetime] NOT NULL,
	[tr_id09] [smalldatetime] NOT NULL,
	[tr_id10] [int] NOT NULL,
	[tr_id23] [char](30) NOT NULL,
	[tr_id24] [char](20) NOT NULL,
	[tr_id25] [char](20) NOT NULL,
	[tr_id26] [char](10) NOT NULL,
	[tr_id27] [char](4) NOT NULL,
	[tr_id28] [float] NOT NULL,
	[tr_id29] [smalldatetime] NOT NULL,
	[tr_id30] [int] NOT NULL,
	[tr_id31] [float] NOT NULL,
	[tr_id32] [float] NOT NULL,
	[tr_status] [char](10) NOT NULL,
	[unit_of_measure] [char](10) NOT NULL,
	[units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[vendor_num] [char](15) NOT NULL,
	[voucher_line] [int] NOT NULL,
	[voucher_num] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(40),
 CONSTRAINT [PJTran0] PRIMARY KEY CLUSTERED 
(
	[fiscalno] ASC,
	[project] ASC,
	[system_cd] ASC,
	[batch_id] ASC,
	[detail_num] ASC,
	company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------
IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_acct')
				
CREATE NONCLUSTERED INDEX [idx_pjtran_acct]
ON [dbo].[PJTran] ([acct])
INCLUDE ([batch_id],[bill_batch_id],[detail_num],[employee],[fiscalno],[pjt_entity],[project],[trans_date],[units],[Company])
GO

/*
IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_batch_id_detail_num_system_cd')
				
CREATE NONCLUSTERED INDEX idx_pjtran_project_trans_date ON [dbo].[PJTran]
     ([project], [trans_date])
 INCLUDE ([pjt_entity], [units], [bill_batch_id]) ON [PRIMARY]


IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_batch_id_detail_num_system_cd')
				
CREATE NONCLUSTERED INDEX idx_pjtran_batch_id_detail_num_system_cd ON [dbo].[PJTran]
     ([batch_id], [detail_num], [system_cd])
 INCLUDE ([acct], [amount], [pjt_entity], [project], [units], [employee], [gl_subacct]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]

IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_project_user2_tr_id23')

CREATE NONCLUSTERED INDEX idx_pjtran_project_user2_tr_id23 ON [dbo].[PJTran]
     ([project], [user2], [tr_id23])
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_trans_date')

CREATE NONCLUSTERED INDEX idx_pjtran_trans_date ON [dbo].[PJTran]
     ([trans_date])
 INCLUDE ([acct], [amount], [pjt_entity], [project], [units], [user2]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]

IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[PJTran]') 
				AND name = N'idx_pjtran_project_fiscalno')
CREATE NONCLUSTERED INDEX idx_pjtran_project_fiscalno ON [dbo].[PJTran]
     ([project], [fiscalno])
 INCLUDE ([gl_subacct], [employee], [bill_batch_id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
*/
--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PJTRAN TO BFGROUP
GRANT SELECT on dbo.PJTRAN TO public

