USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJLABDET]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJLABDET](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[CpnyId_chrg] [varchar](10) NULL,
	[CpnyId_home] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[day1_hr1] [float] NULL,
	[day1_hr2] [float] NULL,
	[day1_hr3] [float] NULL,
	[day2_hr1] [float] NULL,
	[day2_hr2] [float] NULL,
	[day2_hr3] [float] NULL,
	[day3_hr1] [float] NULL,
	[day3_hr2] [float] NULL,
	[day3_hr3] [float] NULL,
	[day4_hr1] [float] NULL,
	[day4_hr2] [float] NULL,
	[day4_hr3] [float] NULL,
	[day5_hr1] [float] NULL,
	[day5_hr2] [float] NULL,
	[day5_hr3] [float] NULL,
	[day6_hr1] [float] NULL,
	[day6_hr2] [float] NULL,
	[day6_hr3] [float] NULL,
	[day7_hr1] [float] NULL,
	[day7_hr2] [float] NULL,
	[day7_hr3] [float] NULL,
	[docnbr] [varchar](10) NULL,
	[earn_type_id] [varchar](10) NULL,
	[gl_acct] [varchar](10) NULL,
	[gl_subacct] [varchar](24) NULL,
	[labor_class_cd] [varchar](4) NULL,
	[labor_stdcost] [float] NULL,
	[ld_desc] [varchar](30) NULL,
	[ld_id01] [varchar](30) NULL,
	[ld_id02] [varchar](30) NULL,
	[ld_id03] [varchar](16) NULL,
	[ld_id04] [varchar](16) NULL,
	[ld_id05] [varchar](4) NULL,
	[ld_id06] [float] NULL,
	[ld_id07] [float] NULL,
	[ld_id08] [smalldatetime] NULL,
	[ld_id09] [smalldatetime] NULL,
	[ld_id10] [int] NULL,
	[ld_id11] [varchar](30) NULL,
	[ld_id12] [varchar](30) NULL,
	[ld_id13] [varchar](20) NULL,
	[ld_id14] [varchar](20) NULL,
	[ld_id15] [varchar](10) NULL,
	[ld_id16] [varchar](10) NULL,
	[ld_id17] [varchar](4) NULL,
	[ld_id18] [float] NULL,
	[ld_id19] [float] NULL,
	[ld_id20] [smalldatetime] NULL,
	[ld_status] [varchar](1) NULL,
	[linenbr] [smallint] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[pjt_entity] [varchar](32) NULL,
	[project] [varchar](16) NULL,
	[rate_source] [varchar](1) NULL,
	[shift] [varchar](7) NULL,
	[SubTask_Name] [varchar](50) NULL,
	[SubTask_UID] [int] NULL,
	[total_amount] [float] NULL,
	[total_hrs] [float] NULL,
	[union_cd] [varchar](10) NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[work_comp_cd] [varchar](6) NULL,
	[work_type] [varchar](2) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJLABDET] ADD  CONSTRAINT [DF_xAPJLABDET_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
