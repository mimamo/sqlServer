USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xAPJPROJ]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xAPJPROJ](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[ASqlUserID] [char](50) NOT NULL,
	[AComputerName] [char](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [char](40) NOT NULL,
	[alloc_method_cd] [char](4) NULL,
	[BaseCuryId] [char](4) NULL,
	[bf_values_switch] [char](1) NULL,
	[billcuryfixedrate] [float] NULL,
	[billcuryid] [char](4) NULL,
	[billratetypeid] [char](6) NULL,
	[budget_version] [char](2) NULL,
	[contract] [char](16) NULL,
	[contract_type] [char](4) NULL,
	[CpnyId] [char](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [char](8) NULL,
	[crtd_user] [char](10) NULL,
	[CuryId] [char](4) NULL,
	[CuryRateType] [char](6) NULL,
	[customer] [char](15) NULL,
	[end_date] [smalldatetime] NULL,
	[gl_subacct] [char](24) NULL,
	[labor_gl_acct] [char](10) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [char](8) NULL,
	[lupd_user] [char](10) NULL,
	[manager1] [char](10) NULL,
	[manager2] [char](10) NULL,
	[MSPData] [char](50) NULL,
	[MSPInterface] [char](1) NULL,
	[MSPProj_ID] [int] NULL,
	[noteid] [int] NULL,
	[opportunityID] [char](36) NULL,
	[pm_id01] [char](30) NULL,
	[pm_id02] [char](30) NULL,
	[pm_id03] [char](16) NULL,
	[pm_id04] [char](16) NULL,
	[pm_id05] [char](4) NULL,
	[pm_id06] [float] NULL,
	[pm_id07] [float] NULL,
	[pm_id08] [smalldatetime] NULL,
	[pm_id09] [smalldatetime] NULL,
	[pm_id10] [int] NULL,
	[pm_id31] [char](30) NULL,
	[pm_id32] [char](30) NULL,
	[pm_id33] [char](20) NULL,
	[pm_id34] [char](20) NULL,
	[pm_id35] [char](10) NULL,
	[pm_id36] [char](10) NULL,
	[pm_id37] [char](4) NULL,
	[pm_id38] [float] NULL,
	[pm_id39] [smalldatetime] NULL,
	[pm_id40] [int] NULL,
	[probability] [smallint] NULL,
	[project] [char](16) NULL,
	[project_desc] [char](30) NULL,
	[purchase_order_num] [char](20) NULL,
	[rate_table_id] [char](4) NULL,
	[shiptoid] [char](10) NULL,
	[slsperid] [char](10) NULL,
	[start_date] [smalldatetime] NULL,
	[status_08] [char](1) NULL,
	[status_09] [char](1) NULL,
	[status_10] [char](1) NULL,
	[status_11] [char](1) NULL,
	[status_12] [char](1) NULL,
	[status_13] [char](1) NULL,
	[status_14] [char](1) NULL,
	[status_15] [char](1) NULL,
	[status_16] [char](1) NULL,
	[status_17] [char](1) NULL,
	[status_18] [char](1) NULL,
	[status_19] [char](1) NULL,
	[status_20] [char](1) NULL,
	[status_ap] [char](1) NULL,
	[status_ar] [char](1) NULL,
	[status_gl] [char](1) NULL,
	[status_in] [char](1) NULL,
	[status_lb] [char](1) NULL,
	[status_pa] [char](1) NULL,
	[status_po] [char](1) NULL,
	[user1] [char](30) NULL,
	[user2] [char](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ASqlUserID]  DEFAULT (CONVERT([char](50),ltrim(rtrim(user_name())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AComputerName]  DEFAULT (CONVERT([char](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AApplication]  DEFAULT (CONVERT([char](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
