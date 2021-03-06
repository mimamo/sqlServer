USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[EDOutbound]    Script Date: 12/21/2015 15:42:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDOutbound](
	[ConvMeth] [char](3) NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[Industry] [char](8) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ReleaseNbr] [char](3) NOT NULL,
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
	[Standard] [char](10) NOT NULL,
	[Trans] [char](3) NOT NULL,
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
	[Version] [char](3) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_ConvMeth]  DEFAULT (' ') FOR [ConvMeth]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_CustId]  DEFAULT (' ') FOR [CustId]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Industry]  DEFAULT (' ') FOR [Industry]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_ReleaseNbr]  DEFAULT (' ') FOR [ReleaseNbr]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Standard]  DEFAULT (' ') FOR [Standard]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Trans]  DEFAULT (' ') FOR [Trans]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDOutbound] ADD  CONSTRAINT [DF_EDOutbound_Version]  DEFAULT (' ') FOR [Version]
GO
