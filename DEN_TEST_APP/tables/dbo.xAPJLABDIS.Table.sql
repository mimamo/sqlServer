USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJLABDIS]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJLABDIS](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[acct] [varchar](16) NULL,
	[amount] [float] NULL,
	[BaseCuryId] [varchar](4) NULL,
	[CpnyId_chrg] [varchar](10) NULL,
	[CpnyId_home] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[CuryEffDate] [smalldatetime] NULL,
	[CuryId] [varchar](4) NULL,
	[CuryMultDiv] [varchar](1) NULL,
	[CuryRate] [float] NULL,
	[CuryRateType] [varchar](6) NULL,
	[CuryTranamt] [float] NULL,
	[Curystdcost] [float] NULL,
	[dl_id01] [varchar](30) NULL,
	[dl_id02] [varchar](30) NULL,
	[dl_id03] [varchar](16) NULL,
	[dl_id04] [varchar](16) NULL,
	[dl_id05] [varchar](4) NULL,
	[dl_id06] [float] NULL,
	[dl_id07] [float] NULL,
	[dl_id08] [smalldatetime] NULL,
	[dl_id09] [smalldatetime] NULL,
	[dl_id10] [int] NULL,
	[dl_id11] [varchar](30) NULL,
	[dl_id12] [varchar](30) NULL,
	[dl_id13] [varchar](20) NULL,
	[dl_id14] [varchar](20) NULL,
	[dl_id15] [varchar](10) NULL,
	[dl_id16] [varchar](10) NULL,
	[dl_id17] [varchar](4) NULL,
	[dl_id18] [float] NULL,
	[dl_id19] [float] NULL,
	[dl_id20] [smalldatetime] NULL,
	[docnbr] [varchar](10) NULL,
	[earn_type_id] [varchar](10) NULL,
	[employee] [varchar](10) NULL,
	[fiscalno] [varchar](6) NULL,
	[gl_acct] [varchar](10) NULL,
	[gl_subacct] [varchar](24) NULL,
	[home_subacct] [varchar](24) NULL,
	[hrs_type] [varchar](4) NULL,
	[labor_class_cd] [varchar](4) NULL,
	[labor_stdcost] [float] NULL,
	[linenbr] [smallint] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[pe_date] [smalldatetime] NULL,
	[pjt_entity] [varchar](32) NULL,
	[premium_hrs] [float] NULL,
	[project] [varchar](16) NULL,
	[rate_source] [varchar](1) NULL,
	[shift] [varchar](7) NULL,
	[status_1] [varchar](2) NULL,
	[status_2] [varchar](2) NULL,
	[status_gl] [varchar](2) NULL,
	[union_cd] [varchar](10) NULL,
	[work_comp_cd] [varchar](6) NULL,
	[work_type] [varchar](2) NULL,
	[worked_hrs] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJLABDIS] ADD  CONSTRAINT [DF_xAPJLABDIS_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
