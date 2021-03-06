USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSLISetup]    Script Date: 12/21/2015 15:42:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLISetup](
	[AutoClientNo] [smallint] NOT NULL,
	[AutoCust] [smallint] NOT NULL,
	[AutoVend] [smallint] NOT NULL,
	[ClientLI] [smallint] NOT NULL,
	[ClientLMS] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EmailAuthPass] [char](100) NOT NULL,
	[EmailAuthType] [char](1) NOT NULL,
	[EmailAuthUser] [char](100) NOT NULL,
	[EmailFromAddress] [char](100) NOT NULL,
	[EmailServer] [char](100) NOT NULL,
	[EmailSubject] [char](100) NOT NULL,
	[LastChkLstNbr] [char](10) NOT NULL,
	[LastClientNo] [char](10) NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PasswordGroup] [char](30) NOT NULL,
	[PlLabel] [char](30) NOT NULL,
	[Region3Label] [char](20) NOT NULL,
	[Sector2Label] [char](20) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[SupervisorGrp] [char](47) NOT NULL,
	[UpdateCustAddr] [smallint] NOT NULL,
	[UpdateVendAddr] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [AutoClientNo]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [AutoCust]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [AutoVend]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [ClientLI]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [ClientLMS]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailAuthPass]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailAuthType]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailAuthUser]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailFromAddress]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailServer]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [EmailSubject]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [LastChkLstNbr]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [LastClientNo]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [PasswordGroup]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [PlLabel]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [Region3Label]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [Sector2Label]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [SupervisorGrp]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [UpdateCustAddr]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0)) FOR [UpdateVendAddr]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLISetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
