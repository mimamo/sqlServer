USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJEMPPJT]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJEMPPJT](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[employee] [varchar](10) NULL,
	[ep_id01] [varchar](30) NULL,
	[ep_id02] [varchar](30) NULL,
	[ep_id03] [varchar](16) NULL,
	[ep_id04] [varchar](16) NULL,
	[ep_id05] [varchar](4) NULL,
	[ep_id06] [float] NULL,
	[ep_id07] [float] NULL,
	[ep_id08] [smalldatetime] NULL,
	[ep_id09] [smalldatetime] NULL,
	[ep_id10] [int] NULL,
	[effect_date] [smalldatetime] NULL,
	[labor_class_cd] [varchar](4) NULL,
	[labor_rate] [float] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[project] [varchar](16) NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJEMPPJT] ADD  CONSTRAINT [DF_xAPJEMPPJT_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
