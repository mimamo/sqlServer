USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xAPJEMPLOY]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xAPJEMPLOY](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[ASqlUserID] [char](50) NOT NULL,
	[AComputerName] [char](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [char](40) NOT NULL,
	[BaseCuryId] [char](4) NULL,
	[CpnyId] [char](10) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [char](8) NULL,
	[crtd_user] [char](10) NULL,
	[CuryId] [char](4) NULL,
	[CuryRateType] [char](6) NULL,
	[date_hired] [smalldatetime] NULL,
	[date_terminated] [smalldatetime] NULL,
	[employee] [char](10) NULL,
	[emp_name] [char](40) NULL,
	[emp_status] [char](1) NULL,
	[emp_type_cd] [char](4) NULL,
	[em_id01] [char](30) NULL,
	[em_id02] [char](30) NULL,
	[em_id03] [char](50) NULL,
	[em_id04] [char](16) NULL,
	[em_id05] [char](4) NULL,
	[em_id06] [float] NULL,
	[em_id07] [float] NULL,
	[em_id08] [smalldatetime] NULL,
	[em_id09] [smalldatetime] NULL,
	[em_id10] [int] NULL,
	[em_id11] [char](30) NULL,
	[em_id12] [char](30) NULL,
	[em_id13] [char](20) NULL,
	[em_id14] [char](20) NULL,
	[em_id15] [char](10) NULL,
	[em_id16] [char](10) NULL,
	[em_id17] [char](4) NULL,
	[em_id18] [float] NULL,
	[em_id19] [smalldatetime] NULL,
	[em_id20] [int] NULL,
	[em_id21] [char](10) NULL,
	[em_id22] [char](10) NULL,
	[em_id23] [char](10) NULL,
	[em_id24] [char](10) NULL,
	[em_id25] [char](10) NULL,
	[exp_approval_max] [float] NULL,
	[gl_subacct] [char](24) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [char](8) NULL,
	[lupd_user] [char](10) NULL,
	[manager1] [char](10) NULL,
	[manager2] [char](10) NULL,
	[MSPData] [char](50) NULL,
	[MSPInterface] [char](1) NULL,
	[MSPRes_UID] [int] NULL,
	[MSPType] [char](1) NULL,
	[noteid] [int] NULL,
	[placeholder] [char](1) NULL,
	[stdday] [smallint] NULL,
	[Stdweek] [smallint] NULL,
	[Subcontractor] [char](1) NULL,
	[user1] [char](30) NULL,
	[user2] [char](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[user_id] [char](50) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ASqlUserID]  DEFAULT (CONVERT([char](50),ltrim(rtrim(user_name())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AComputerName]  DEFAULT (CONVERT([char](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJEMPLOY] ADD  CONSTRAINT [DF_xAPJEMPLOY_AApplication]  DEFAULT (CONVERT([char](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
