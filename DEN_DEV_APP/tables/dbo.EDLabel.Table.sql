USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[EDLabel]    Script Date: 12/21/2015 14:05:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDLabel](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Name] [char](30) NOT NULL,
	[PrinterName] [char](20) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_Name]  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_PrinterName]  DEFAULT (' ') FOR [PrinterName]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDLabel] ADD  CONSTRAINT [DF_EDLabel_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
