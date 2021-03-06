USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xAPJPROJ]    Script Date: 12/21/2015 15:54:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJPROJ](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[alloc_method_cd] [varchar](4) NULL,
	[BaseCuryId] [varchar](4) NULL,
	[bf_values_switch] [varchar](1) NULL,
	[billcuryfixedrate] [float] NULL,
	[billcuryid] [varchar](4) NULL,
	[billing_setup] [varchar](1) NULL,
	[billratetypeid] [varchar](6) NULL,
	[budget_type] [varchar](1) NULL,
	[budget_version] [varchar](2) NULL,
	[contract] [varchar](16) NULL,
	[contract_type] [varchar](4) NULL,
	[CpnyId] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[CuryId] [varchar](4) NULL,
	[CuryRateType] [varchar](6) NULL,
	[customer] [varchar](15) NULL,
	[end_date] [smalldatetime] NULL,
	[gl_subacct] [varchar](24) NULL,
	[labor_gl_acct] [varchar](10) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[manager1] [varchar](10) NULL,
	[manager2] [varchar](10) NULL,
	[MSPData] [varchar](50) NULL,
	[MSPInterface] [varchar](1) NULL,
	[MSPProj_ID] [int] NULL,
	[noteid] [int] NULL,
	[opportunityID] [varchar](36) NULL,
	[pm_id01] [varchar](30) NULL,
	[pm_id02] [varchar](30) NULL,
	[pm_id03] [varchar](16) NULL,
	[pm_id04] [varchar](16) NULL,
	[pm_id05] [varchar](4) NULL,
	[pm_id06] [float] NULL,
	[pm_id07] [float] NULL,
	[pm_id08] [smalldatetime] NULL,
	[pm_id09] [smalldatetime] NULL,
	[pm_id10] [int] NULL,
	[pm_id31] [varchar](30) NULL,
	[pm_id32] [varchar](30) NULL,
	[pm_id33] [varchar](20) NULL,
	[pm_id34] [varchar](20) NULL,
	[pm_id35] [varchar](10) NULL,
	[pm_id36] [varchar](10) NULL,
	[pm_id37] [varchar](4) NULL,
	[pm_id38] [float] NULL,
	[pm_id39] [smalldatetime] NULL,
	[pm_id40] [int] NULL,
	[probability] [smallint] NULL,
	[project] [varchar](16) NULL,
	[project_desc] [varchar](60) NULL,
	[purchase_order_num] [varchar](20) NULL,
	[rate_table_id] [varchar](4) NULL,
	[shiptoid] [varchar](10) NULL,
	[slsperid] [varchar](10) NULL,
	[start_date] [smalldatetime] NULL,
	[status_08] [varchar](1) NULL,
	[status_09] [varchar](1) NULL,
	[status_10] [varchar](1) NULL,
	[status_11] [varchar](1) NULL,
	[status_12] [varchar](1) NULL,
	[status_13] [varchar](1) NULL,
	[status_14] [varchar](1) NULL,
	[status_15] [varchar](1) NULL,
	[status_16] [varchar](1) NULL,
	[status_17] [varchar](1) NULL,
	[status_18] [varchar](1) NULL,
	[status_19] [varchar](1) NULL,
	[status_20] [varchar](1) NULL,
	[status_ap] [varchar](1) NULL,
	[status_ar] [varchar](1) NULL,
	[status_gl] [varchar](1) NULL,
	[status_in] [varchar](1) NULL,
	[status_lb] [varchar](1) NULL,
	[status_pa] [varchar](1) NULL,
	[status_po] [varchar](1) NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPROJ] ADD  CONSTRAINT [DF_xAPJPROJ_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
