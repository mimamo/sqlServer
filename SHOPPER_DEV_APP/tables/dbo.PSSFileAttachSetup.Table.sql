USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFileAttachSetup]    Script Date: 12/21/2015 14:33:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFileAttachSetup](
	[CleanScnImg] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefPath] [char](255) NOT NULL,
	[DisplayFirst] [smallint] NOT NULL,
	[ImageDb] [char](100) NOT NULL,
	[ImageServer] [char](100) NOT NULL,
	[LookupRegistry] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[SQLPassword] [char](30) NOT NULL,
	[SQLTrusted] [smallint] NOT NULL,
	[SQLUsername] [char](30) NOT NULL,
	[StoreInSQL] [smallint] NOT NULL,
	[UnlockKey] [char](25) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Version] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0)) FOR [CleanScnImg]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [DefPath]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0)) FOR [DisplayFirst]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [ImageDb]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [ImageServer]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0)) FOR [LookupRegistry]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [SQLPassword]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0)) FOR [SQLTrusted]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [SQLUsername]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0)) FOR [StoreInSQL]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [UnlockKey]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFileAttachSetup] ADD  DEFAULT ('') FOR [Version]
GO
