USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xAPJPROJMX]    Script Date: 12/21/2015 16:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJPROJMX](
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
	[acct_billing] [varchar](16) NULL,
	[acct_overmax] [varchar](16) NULL,
	[acct_overmax_offset] [varchar](16) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[gl_acct_overmax] [varchar](10) NULL,
	[gl_acct_offset] [varchar](10) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[Max_amount] [float] NULL,
	[Max_units] [float] NULL,
	[mx_id01] [varchar](30) NULL,
	[mx_id02] [varchar](30) NULL,
	[mx_id03] [varchar](16) NULL,
	[mx_id04] [varchar](16) NULL,
	[mx_id05] [varchar](4) NULL,
	[mx_id06] [float] NULL,
	[mx_id07] [float] NULL,
	[mx_id08] [smalldatetime] NULL,
	[mx_id09] [smalldatetime] NULL,
	[mx_id10] [int] NULL,
	[pjt_entity] [varchar](32) NULL,
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
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPROJMX] ADD  CONSTRAINT [DF_xAPJPROJMX_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
