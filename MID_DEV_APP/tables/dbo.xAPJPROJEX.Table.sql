USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xAPJPROJEX]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJPROJEX](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[computed_date] [smalldatetime] NULL,
	[computed_pc] [float] NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[entered_pc] [float] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[PM_ID11] [varchar](30) NULL,
	[PM_ID12] [varchar](30) NULL,
	[PM_ID13] [varchar](16) NULL,
	[PM_ID14] [varchar](16) NULL,
	[PM_ID15] [varchar](4) NULL,
	[PM_ID16] [float] NULL,
	[PM_ID17] [float] NULL,
	[PM_ID18] [smalldatetime] NULL,
	[PM_ID19] [smalldatetime] NULL,
	[PM_ID20] [int] NULL,
	[PM_ID21] [varchar](30) NULL,
	[PM_ID22] [varchar](30) NULL,
	[PM_ID23] [varchar](16) NULL,
	[PM_ID24] [varchar](16) NULL,
	[PM_ID25] [varchar](4) NULL,
	[PM_ID26] [float] NULL,
	[PM_ID27] [float] NULL,
	[PM_ID28] [smalldatetime] NULL,
	[PM_ID29] [smalldatetime] NULL,
	[PM_ID30] [int] NULL,
	[proj_date1] [smalldatetime] NULL,
	[proj_date2] [smalldatetime] NULL,
	[proj_date3] [smalldatetime] NULL,
	[proj_date4] [smalldatetime] NULL,
	[project] [varchar](16) NULL,
	[rate_table_labor] [varchar](4) NULL,
	[revision_date] [smalldatetime] NULL,
	[rev_flag] [varchar](1) NULL,
	[rev_type] [varchar](2) NULL,
	[work_comp_cd] [varchar](6) NULL,
	[work_location] [varchar](6) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPROJEX] ADD  CONSTRAINT [DF_xAPJPROJEX_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
