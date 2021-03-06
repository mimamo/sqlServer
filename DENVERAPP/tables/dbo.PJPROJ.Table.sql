USE [DENVERAPP]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   DENVERAPP.dbo.PJPROJ
*
*   Creator:     
*   Date:         
*   
*
*   Notes:      select top 100 * from denverapp.dbo.PJPROJ    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/29/2016	Adding a new index, dropping some unused ones.
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PJPROJ') < 1

CREATE TABLE [dbo].[PJPROJ](
	[alloc_method_cd] [char](4) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[bf_values_switch] [char](1) NOT NULL,
	[billcuryfixedrate] [float] NOT NULL,
	[billcuryid] [char](4) NOT NULL,
	[billing_setup] [char](1) NOT NULL,
	[billratetypeid] [char](6) NOT NULL,
	[budget_type] [char](1) NOT NULL,
	[budget_version] [char](2) NOT NULL,
	[contract] [char](16) NOT NULL,
	[contract_type] [char](4) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[customer] [char](15) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[labor_gl_acct] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[manager1] [char](10) NOT NULL,
	[manager2] [char](10) NOT NULL,
	[MSPData] [char](50) NOT NULL,
	[MSPInterface] [char](1) NOT NULL,
	[MSPProj_ID] [int] NOT NULL,
	[noteid] [int] NOT NULL,
	[opportunityID] [char](36) NOT NULL,
	[pm_id01] [char](30) NOT NULL,
	[pm_id02] [char](30) NOT NULL,
	[pm_id03] [char](16) NOT NULL,
	[pm_id04] [char](16) NOT NULL,
	[pm_id05] [char](4) NOT NULL,
	[pm_id06] [float] NOT NULL,
	[pm_id07] [float] NOT NULL,
	[pm_id08] [smalldatetime] NOT NULL,
	[pm_id09] [smalldatetime] NOT NULL,
	[pm_id10] [int] NOT NULL,
	[pm_id31] [char](30) NOT NULL,
	[pm_id32] [char](30) NOT NULL,
	[pm_id33] [char](20) NOT NULL,
	[pm_id34] [char](20) NOT NULL,
	[pm_id35] [char](10) NOT NULL,
	[pm_id36] [char](10) NOT NULL,
	[pm_id37] [char](4) NOT NULL,
	[pm_id38] [float] NOT NULL,
	[pm_id39] [smalldatetime] NOT NULL,
	[pm_id40] [int] NOT NULL,
	[probability] [smallint] NOT NULL,
	[project] [char](16) NOT NULL,
	[project_desc] [char](60) NOT NULL,
	[purchase_order_num] [char](20) NOT NULL,
	[rate_table_id] [char](4) NOT NULL,
	[shiptoid] [char](10) NOT NULL,
	[slsperid] [char](10) NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[status_08] [char](1) NOT NULL,
	[status_09] [char](1) NOT NULL,
	[status_10] [char](1) NOT NULL,
	[status_11] [char](1) NOT NULL,
	[status_12] [char](1) NOT NULL,
	[status_13] [char](1) NOT NULL,
	[status_14] [char](1) NOT NULL,
	[status_15] [char](1) NOT NULL,
	[status_16] [char](1) NOT NULL,
	[status_17] [char](1) NOT NULL,
	[status_18] [char](1) NOT NULL,
	[status_19] [char](1) NOT NULL,
	[status_20] [char](1) NOT NULL,
	[status_ap] [char](1) NOT NULL,
	[status_ar] [char](1) NOT NULL,
	[status_gl] [char](1) NOT NULL,
	[status_in] [char](1) NOT NULL,
	[status_lb] [char](1) NOT NULL,
	[status_pa] [char](1) NOT NULL,
	[status_po] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjproj0] PRIMARY KEY CLUSTERED 
(
	[project] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'idx_pssd_289_288')
    DROP INDEX idx_pssd_289_288 ON [dbo].[PJPROJ]
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'idx_pssd_196_195')
    DROP INDEX idx_pssd_196_195 ON [dbo].[PJPROJ]
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'pjproj2')
    DROP INDEX pjproj2 ON [dbo].[PJPROJ]
   
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'pjproj1')
    DROP INDEX pjproj1 ON [dbo].[PJPROJ]        
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'idx_pssd_651_650')
    DROP INDEX idx_pssd_651_650 ON [dbo].[PJPROJ]

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'idx_pssd_194_193')
    DROP INDEX idx_pssd_194_193 ON [dbo].[PJPROJ]
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'pjproj5')
    DROP INDEX pjproj5 ON [dbo].[PJPROJ]
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'pjproj6')
    DROP INDEX pjproj6 ON [dbo].[PJPROJ]

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PJPROJ]') AND name = N'pjproj7')
    DROP INDEX pjproj7 ON [dbo].[PJPROJ]
    

