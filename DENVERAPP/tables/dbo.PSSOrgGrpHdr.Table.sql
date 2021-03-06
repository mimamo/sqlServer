USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSOrgGrpHdr]    Script Date: 12/21/2015 15:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSOrgGrpHdr](
	[Addr1] [char](100) NOT NULL,
	[Addr2] [char](100) NOT NULL,
	[AddrId] [char](10) NOT NULL,
	[City] [char](60) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Email] [char](100) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MainContact] [char](60) NOT NULL,
	[OrgCode] [char](10) NOT NULL,
	[OrgName] [char](100) NOT NULL,
	[PersonCode] [char](51) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[PhoneExt] [char](60) NOT NULL,
	[State] [char](2) NOT NULL,
	[Title] [char](10) NOT NULL,
	[TotAssets] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](30) NOT NULL,
	[User6] [char](30) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [AddrId]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [MainContact]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [OrgCode]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [OrgName]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [PersonCode]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [PhoneExt]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Title]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ((0.00)) FOR [TotAssets]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSOrgGrpHdr] ADD  DEFAULT ('') FOR [Zip]
GO
