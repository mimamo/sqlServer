USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJTIMDET]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJTIMDET](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[cert_pay_sw] [varchar](1) NULL,
	[CpnyId_chrg] [varchar](10) NULL,
	[CpnyId_eq_home] [varchar](10) NULL,
	[CpnyId_home] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[docnbr] [varchar](10) NULL,
	[earn_type_id] [varchar](10) NULL,
	[employee] [varchar](10) NULL,
	[elapsed_time] [varchar](4) NULL,
	[end_time] [varchar](4) NULL,
	[equip_amt] [float] NULL,
	[equip_home_subacct] [varchar](24) NULL,
	[equip_id] [varchar](10) NULL,
	[equip_rate] [float] NULL,
	[equip_rate_cd] [varchar](5) NULL,
	[equip_rate_indicator] [varchar](1) NULL,
	[equip_units] [float] NULL,
	[equip_uom] [varchar](6) NULL,
	[gl_acct] [varchar](10) NULL,
	[gl_subacct] [varchar](24) NULL,
	[group_code] [varchar](2) NULL,
	[labor_amt] [float] NULL,
	[labor_class_cd] [varchar](4) NULL,
	[labor_rate] [float] NULL,
	[labor_rate_indicator] [varchar](1) NULL,
	[linenbr] [smallint] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[ot1_hours] [float] NULL,
	[ot2_hours] [float] NULL,
	[pjt_entity] [varchar](32) NULL,
	[project] [varchar](16) NULL,
	[reg_hours] [float] NULL,
	[shift] [varchar](7) NULL,
	[start_time] [varchar](4) NULL,
	[tl_date] [smalldatetime] NULL,
	[tl_id01] [varchar](30) NULL,
	[tl_id02] [varchar](30) NULL,
	[tl_id03] [varchar](20) NULL,
	[tl_id04] [varchar](20) NULL,
	[tl_id05] [varchar](10) NULL,
	[tl_id06] [varchar](10) NULL,
	[tl_id07] [varchar](4) NULL,
	[tl_id08] [float] NULL,
	[tl_id09] [smalldatetime] NULL,
	[tl_id10] [int] NULL,
	[tl_id11] [varchar](30) NULL,
	[tl_id12] [varchar](30) NULL,
	[tl_id13] [varchar](20) NULL,
	[tl_id14] [varchar](20) NULL,
	[tl_id15] [varchar](10) NULL,
	[tl_id16] [varchar](10) NULL,
	[tl_id17] [varchar](4) NULL,
	[tl_id18] [float] NULL,
	[tl_id19] [smalldatetime] NULL,
	[tl_id20] [int] NULL,
	[tl_status] [varchar](1) NULL,
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
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJTIMDET] ADD  CONSTRAINT [DF_xAPJTIMDET_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
