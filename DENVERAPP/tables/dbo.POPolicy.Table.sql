USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[POPolicy]    Script Date: 12/21/2015 15:42:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POPolicy](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PolicyID] [char](10) NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_PolicyID]  DEFAULT (' ') FOR [PolicyID]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POPolicy] ADD  CONSTRAINT [DF_POPolicy_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
