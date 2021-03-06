USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xAPJEMPLOY]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJEMPLOY](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[BaseCuryId] [varchar](4) NULL,
	[CpnyId] [varchar](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[CuryId] [varchar](4) NULL,
	[CuryRateType] [varchar](6) NULL,
	[date_hired] [smalldatetime] NULL,
	[date_terminated] [smalldatetime] NULL,
	[employee] [varchar](10) NULL,
	[emp_name] [varchar](60) NULL,
	[emp_status] [varchar](1) NULL,
	[emp_type_cd] [varchar](4) NULL,
	[em_id01] [varchar](30) NULL,
	[em_id02] [varchar](30) NULL,
	[em_id03] [varchar](50) NULL,
	[em_id04] [varchar](16) NULL,
	[em_id05] [varchar](4) NULL,
	[em_id06] [float] NULL,
	[em_id07] [float] NULL,
	[em_id08] [smalldatetime] NULL,
	[em_id09] [smalldatetime] NULL,
	[em_id10] [int] NULL,
	[em_id11] [varchar](30) NULL,
	[em_id12] [varchar](30) NULL,
	[em_id13] [varchar](20) NULL,
	[em_id14] [varchar](20) NULL,
	[em_id15] [varchar](10) NULL,
	[em_id16] [varchar](10) NULL,
	[em_id17] [varchar](4) NULL,
	[em_id18] [float] NULL,
	[em_id19] [smalldatetime] NULL,
	[em_id20] [int] NULL,
	[em_id21] [varchar](10) NULL,
	[em_id22] [varchar](10) NULL,
	[em_id23] [varchar](10) NULL,
	[em_id24] [varchar](10) NULL,
	[em_id25] [varchar](10) NULL,
	[exp_approval_max] [float] NULL,
	[gl_subacct] [varchar](24) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[manager1] [varchar](10) NULL,
	[manager2] [varchar](10) NULL,
	[MSPData] [varchar](50) NULL,
	[MSPInterface] [varchar](1) NULL,
	[MSPRes_UID] [int] NULL,
	[MSPType] [varchar](1) NULL,
	[noteid] [int] NULL,
	[placeholder] [varchar](1) NULL,
	[stdday] [smallint] NULL,
	[Stdweek] [smallint] NULL,
	[Subcontractor] [varchar](1) NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[user_id] [varchar](50) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
