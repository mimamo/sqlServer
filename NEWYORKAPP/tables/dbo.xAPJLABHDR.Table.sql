USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xAPJLABHDR]    Script Date: 12/21/2015 16:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJLABHDR](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[Approver] [varchar](10) NULL,
	[BaseCuryId] [varchar](4) NULL,
	[CpnyId_home] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[CuryEffDate] [smalldatetime] NULL,
	[CuryId] [varchar](4) NULL,
	[CuryMultDiv] [varchar](1) NULL,
	[CuryRate] [float] NULL,
	[CuryRateType] [varchar](6) NULL,
	[docnbr] [varchar](10) NULL,
	[employee] [varchar](10) NULL,
	[fiscalno] [varchar](6) NULL,
	[le_id01] [varchar](30) NULL,
	[le_id02] [varchar](30) NULL,
	[le_id03] [varchar](16) NULL,
	[le_id04] [varchar](16) NULL,
	[le_id05] [varchar](4) NULL,
	[le_id06] [float] NULL,
	[le_id07] [float] NULL,
	[le_id08] [smalldatetime] NULL,
	[le_id09] [smalldatetime] NULL,
	[le_id10] [int] NULL,
	[le_key] [varchar](30) NULL,
	[le_status] [varchar](1) NULL,
	[le_type] [varchar](2) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[period_num] [varchar](6) NULL,
	[pe_date] [smalldatetime] NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[week_num] [varchar](2) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJLABHDR] ADD  CONSTRAINT [DF_xAPJLABHDR_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
