USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJTIMHDR]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJTIMHDR](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[approver] [varchar](10) NULL,
	[BaseCuryId] [varchar](4) NULL,
	[cpnyId] [varchar](10) NULL,
	[crew_cd] [varchar](7) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[CuryEffDate] [smalldatetime] NULL,
	[CuryId] [varchar](4) NULL,
	[CuryMultDiv] [varchar](1) NULL,
	[CuryRate] [float] NULL,
	[CuryRateType] [varchar](6) NULL,
	[docnbr] [varchar](10) NULL,
	[end_time] [varchar](4) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[multi_emp_sw] [varchar](1) NULL,
	[noteid] [int] NULL,
	[percent_comp] [float] NULL,
	[preparer_id] [varchar](10) NULL,
	[project] [varchar](16) NULL,
	[pjt_entity] [varchar](32) NULL,
	[shift] [varchar](7) NULL,
	[start_time] [varchar](4) NULL,
	[th_comment] [varchar](30) NULL,
	[th_date] [smalldatetime] NULL,
	[th_key] [varchar](30) NULL,
	[th_id01] [varchar](30) NULL,
	[th_id02] [varchar](30) NULL,
	[th_id03] [varchar](20) NULL,
	[th_id04] [varchar](20) NULL,
	[th_id05] [varchar](10) NULL,
	[th_id06] [varchar](10) NULL,
	[th_id07] [varchar](4) NULL,
	[th_id08] [float] NULL,
	[th_id09] [smalldatetime] NULL,
	[th_id10] [int] NULL,
	[th_id11] [varchar](30) NULL,
	[th_id12] [varchar](30) NULL,
	[th_id13] [varchar](20) NULL,
	[th_id14] [varchar](20) NULL,
	[th_id15] [varchar](10) NULL,
	[th_id16] [varchar](10) NULL,
	[th_id17] [varchar](4) NULL,
	[th_id18] [float] NULL,
	[th_id19] [smalldatetime] NULL,
	[th_id20] [int] NULL,
	[th_status] [varchar](1) NULL,
	[th_type] [varchar](2) NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJTIMHDR] ADD  CONSTRAINT [DF_xAPJTIMHDR_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
