USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xAPJPROJEM]    Script Date: 12/21/2015 15:54:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJPROJEM](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[access_data1] [varchar](1) NULL,
	[access_data2] [varchar](32) NULL,
	[access_insert] [varchar](1) NULL,
	[access_update] [varchar](1) NULL,
	[access_view] [varchar](1) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[employee] [varchar](10) NULL,
	[labor_class_cd] [varchar](4) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[project] [varchar](16) NULL,
	[pv_id01] [varchar](32) NULL,
	[pv_id02] [varchar](32) NULL,
	[pv_id03] [varchar](16) NULL,
	[pv_id04] [varchar](16) NULL,
	[pv_id05] [varchar](4) NULL,
	[pv_id06] [float] NULL,
	[pv_id07] [float] NULL,
	[pv_id08] [smalldatetime] NULL,
	[pv_id09] [smalldatetime] NULL,
	[pv_id10] [int] NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPROJEM] ADD  CONSTRAINT [DF_xAPJPROJEM_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
